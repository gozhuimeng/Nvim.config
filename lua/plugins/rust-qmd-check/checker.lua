-- plugins/rust-qmd-check/checker.lua
--
-- 用途：把 qmd 里的 ```{rust} 代码块交给 rustc / cargo check 检查，
--       再把编译器诊断按原行号显示回 qmd buffer。
--
-- 它不注册 LSP，只使用 Neovim 自带的 vim.diagnostic，所以：
--   * 不需要 rust-analyzer，也不需要 otter；
--   * 诊断 UI 和你平时看到的完全一样（下划线、virtual text、signs）。
--
-- 由同目录的 init.lua（lazy spec）在启动时调用 setup()，
-- 具体说明见同目录 README.md。
--
-- 工作流程：
--   qmd 代码块 --抽取(保留行号)--> 临时 .rs --rustc/cargo--> JSON 诊断 --映射--> vim.diagnostic

local M = {}

M.config = {
  -- 停止输入多久后检查（毫秒）
  debounce_ms = 300,
  -- 在哪些 filetype 上生效（qmd 一般被识别为 quarto，有的配置是 qmd）
  filetypes = { "quarto", "qmd" },
  -- "auto" = 有 :dep 用 cargo，否则用 rustc；也可强制 "rustc" / "cargo"
  command = "auto",
  -- 没有 Cargo.toml 时 rustc 使用的 edition
  default_edition = "2021",
}

local ns = vim.api.nvim_create_namespace("rust_qmd_check")
local timer = vim.uv.new_timer()
local active_job = nil
local pending_buf = nil
local warned = {}
-- 需要清理的生成文件（cargo 模式），退出时删除
local generated_files = {}

local function warn_once(key, msg)
  if warned[key] then
    return
  end
  warned[key] = true
  vim.notify(msg, vim.log.levels.WARN)
end

--------------------------------------------------------------------------------
-- 1. 抽取：把 qmd 里的 rust 代码按原行号取出来
--------------------------------------------------------------------------------

---从 qmd 源码中抽出 rust 代码。
---返回的 table 与原文行号一一对应（非 rust 行留空字符串），
---这样编译器报的行号可以直接映射回 qmd。
---@param lines string[]
---@return string[] code, boolean has_dep, boolean has_rust
local function extract(lines)
  local code = {}
  local in_chunk = false
  local fence = nil
  local has_dep = false
  local has_rust = false

  for i, line in ipairs(lines) do
    if not in_chunk then
      -- 打开围栏：```{rust} / ```rust / ```{.rust} 都算，ticks 至少 3 个
      local ticks, info = line:match("^%s*(`+)(.*)$")
      if ticks and #ticks >= 3 and info:match("rust") then
        in_chunk = true
        fence = ticks
        has_rust = true
      end
      code[i] = ""
    else
      -- 关闭围栏：至少和打开时一样长的反引号
      local closing = line:match("^%s*(`+)%s*$")
      if closing and #closing >= 3 and #closing >= #fence then
        in_chunk = false
        fence = nil
        code[i] = ""
      elseif line:match("^%s*:dep%s") then
        -- evcxr 的 :dep 不是合法 Rust，检查时跳过（行号仍保留）
        has_dep = true
        code[i] = ""
      else
        code[i] = line
      end
    end
  end

  return code, has_dep, has_rust
end

--------------------------------------------------------------------------------
-- 2. 包裹：让“顶层语句”和“fn main”两种写法都能通过语法解析
--------------------------------------------------------------------------------

---把 `fn main(` 这一行的函数名换掉（保留缩进、pub 和行内其余内容）。
local function rename_main(line, new_name)
  local indent, prefix, paren, tail = line:match("^(%s*)(pub%s+fn%s+)main(%s*%()(.*)$")
  if not indent then
    indent, prefix, paren, tail = line:match("^(%s*)(fn%s+)main(%s*%()(.*)$")
  end
  if not indent then
    return line
  end
  return indent .. prefix .. new_name .. paren .. tail
end

---同一文档里出现多个 fn main 会重名，从第二个开始改名；
---顶层重复的 use 也会冲突，保留第一处、其余换成空行。
---只改定义行，不影响其它行号。
---@param code string[]
---@return string[]
local function prepare_code(code)
  local main_count = 0
  local uses = {}
  local out = {}
  for i, line in ipairs(code) do
    if line:match("^%s*fn%s+main%s*%(") or line:match("^%s*pub%s+fn%s+main%s*%(") then
      main_count = main_count + 1
      if main_count > 1 then
        line = rename_main(line, "__qmd_main_" .. main_count)
      end
    end

    -- 顶层（无缩进）完全相同的 use 只保留第一次
    local use_line = line:match("^(use%s+.-;)%s*$")
    if use_line then
      if uses[use_line] then
        line = ""
      else
        uses[use_line] = true
      end
    end

    out[i] = line
  end
  return out
end

---写一个可编译的临时源文件。
---外层包一个 fn main，这样 evcxr 风格的顶层语句也能被检查；
---代价是所有行号 +1，解析诊断时再减回去。
local function write_source(path, code)
  local out = { "#[allow(dead_code)] fn main() {" }
  vim.list_extend(out, prepare_code(code))
  out[#out + 1] = "}"
  vim.fn.writefile(out, path)
end

--------------------------------------------------------------------------------
-- 3. 项目信息：Cargo.toml 的位置、edition、bin 名
--------------------------------------------------------------------------------

local function cargo_root(buf)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
  return vim.fs.root(dir, { "Cargo.toml" })
end

---从 Cargo.toml 读 edition；读不到就用默认值。
local function project_edition(root)
  if not root then
    return M.config.default_edition
  end
  local ok, lines = pcall(vim.fn.readfile, root .. "/Cargo.toml")
  if ok then
    for _, line in ipairs(lines) do
      local edition = line:match('^%s*edition%s*=%s*"([%d]+)"')
      if edition then
        return edition
      end
    end
  end
  return M.config.default_edition
end

---生成一个合法的 bin 名：qmd_basics_variables
local function bin_name(root, file)
  local rel = vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ":t")
  return "qmd_" .. rel:gsub("%.qmd$", ""):gsub("[^%w]+", "_")
end

--------------------------------------------------------------------------------
-- 4. 解析：rustc / cargo 的 JSON -> vim.diagnostic
--------------------------------------------------------------------------------

local severity = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  note = vim.diagnostic.severity.INFO,
  help = vim.diagnostic.severity.HINT,
}

---@param text string 编译器的原始输出（stderr + stdout）
---@param generated string 生成文件路径（只保留这个文件里的诊断）
---@param offset integer 行号偏移：wrap 头部占了几行
local function parse(text, generated, offset)
  local diags = {}
  local seen = {}
  local base = vim.fn.fnamemodify(generated, ":t")

  for line in text:gmatch("[^\n]+") do
    local ok, msg = pcall(vim.json.decode, line)
    if ok and type(msg) == "table" then
      -- cargo 把诊断包在 compiler-message 里，rustc 直接就是诊断本身
      local d = msg
      if msg.reason == "compiler-message" then
        d = msg.message
      end

      if d and d.level and d.spans then
        -- 优先取主 span，没有就取第一个
        local span
        for _, s in ipairs(d.spans) do
          if s.is_primary then
            span = s
            break
          end
        end
        span = span or d.spans[1]

        -- 只保留生成文件里的诊断（依赖库里的错误不显示）
        local same_file = span
          and (
            vim.fn.fnamemodify(span.file_name, ":t") == base
            or vim.fs.normalize(span.file_name) == vim.fs.normalize(generated)
          )

        if same_file and span.line_start > offset then
          local lnum = span.line_start - offset - 1
          local col = math.max(0, span.column_start - 1)
          local key = lnum .. ":" .. col .. ":" .. d.message
          if not seen[key] then
            seen[key] = true
            diags[#diags + 1] = {
              lnum = lnum,
              col = col,
              end_lnum = math.max(0, span.line_end - offset - 1),
              end_col = math.max(0, span.column_end - 1),
              severity = severity[d.level] or vim.diagnostic.severity.INFO,
              message = d.message,
              source = "rustc",
            }
          end
        end
      end
    end
  end

  return diags
end

--------------------------------------------------------------------------------
-- 5. 检查：选 rustc 还是 cargo，跑完写回诊断
--------------------------------------------------------------------------------

local function cleanup(path)
  if path and vim.uv.fs_stat(path) then
    pcall(vim.uv.fs_unlink, path)
  end
end

local function check(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local code, has_dep, has_rust = extract(lines)
  if not has_rust then
    vim.diagnostic.reset(ns, buf)
    return
  end

  local file = vim.api.nvim_buf_get_name(buf)
  local root = cargo_root(buf)
  local mode = M.config.command
  if mode == "auto" then
    mode = (has_dep and root) and "cargo" or "rustc"
  end

  -- 有 :dep 但没有 Cargo 工程：退化成 rustc，并提醒一次
  if has_dep and not root then
    warn_once(
      "nodep",
      "[rust_qmd_check] 代码里用了 :dep，但没有找到 Cargo.toml，暂时只用 rustc 检查"
    )
  end
  if mode == "cargo" and not root then
    warn_once("nocargo", "[rust_qmd_check] 没找到 Cargo.toml，改用 rustc 检查")
    mode = "rustc"
  end

  local cmd, cwd, generated

  if mode == "cargo" then
    local name = bin_name(root, file)
    generated = root .. "/src/bin/" .. name .. ".rs"
    vim.fn.mkdir(vim.fs.dirname(generated), "p")
    write_source(generated, code)
    generated_files[generated] = true
    cmd = { "cargo", "check", "--quiet", "--message-format=json", "--bin", name }
    cwd = root
  else
    generated = vim.fn.tempname() .. ".rs"
    write_source(generated, code)
    cmd = {
      "rustc",
      "--edition=" .. project_edition(root),
      "--crate-type=bin",
      "--emit=metadata",
      "--error-format=json",
      "--out-dir",
      vim.fs.dirname(generated),
      generated,
    }
    cwd = root or vim.fs.dirname(file)
  end

  -- 新的检查开始前，结束上一个还没跑完的
  if active_job then
    pcall(active_job.kill, active_job, 15)
    active_job = nil
  end

  active_job = vim.system(cmd, { cwd = cwd, text = true }, function(res)
    active_job = nil
    -- rustc 的 JSON 在 stderr，cargo 的 JSON 在 stdout，一起解析
    local text = (res.stdout or "") .. "\n" .. (res.stderr or "")
    local diags = parse(text, generated, 1) -- 头部占 1 行，所以 offset = 1
    if mode == "cargo" then
      cleanup(generated)
      generated_files[generated] = nil
    end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.diagnostic.set(ns, buf, diags)
      end
    end)
  end)
end

--------------------------------------------------------------------------------
-- 6. 触发：防抖 + autocmd
--------------------------------------------------------------------------------

local function schedule(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  pending_buf = buf
  timer:stop()
  timer:start(
    M.config.debounce_ms,
    0,
    vim.schedule_wrap(function()
      if pending_buf and vim.api.nvim_buf_is_valid(pending_buf) then
        check(pending_buf)
      end
    end)
  )
end

---启用检查器。可选参数会合并进 M.config。
---@param opts table?
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  local group = vim.api.nvim_create_augroup("RustQmdCheck", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = M.config.filetypes,
    callback = function(args)
      -- 同一个 buffer 只配置一次（:setfiletype 可能触发多次）
      if vim.b[args.buf].rust_qmd_check then
        return
      end
      local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      local _, _, has_rust = extract(lines)
      if not has_rust then
        return
      end
      vim.b[args.buf].rust_qmd_check = true
      vim.api.nvim_create_autocmd(
        { "TextChanged", "TextChangedI", "InsertLeave", "BufWritePost", "BufEnter" },
        {
          group = group,
          buffer = args.buf,
          callback = function()
            schedule(args.buf)
          end,
        }
      )
      schedule(args.buf)
    end,
  })

  -- 退出时清理 cargo 模式生成的临时文件
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      for path in pairs(generated_files) do
        cleanup(path)
      end
    end,
  })
end

return M
