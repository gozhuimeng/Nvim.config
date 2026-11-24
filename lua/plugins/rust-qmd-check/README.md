# rust_qmd_check

在 Neovim 里检查 Quarto `.qmd` 中的 ` ```{rust} ` 代码块，把 **rustc / cargo check**
的诊断显示回 qmd 原文的位置（下划线、virtual text、signs 都和你平时看到的一样）。

它只用 Neovim 自带的 `vim.diagnostic`，**不注册 LSP、不新增插件、不依赖 otter**。
加载方式是 lazy.nvim 的一个 virtual spec，不需要改 `init.lua`。

文件都在 `lua/plugins/rust-qmd-check/`：

```
lua/plugins/rust-qmd-check/
├── init.lua      -- lazy spec，负责调用 setup()
├── checker.lua   -- 检查器实现
└── README.md     -- 本文件
```

## 为什么不用 rust-analyzer 直接检查

qmd 里的代码不在 Cargo target 里，rust-analyzer 只按「游离文件」分析；
即使把它加进 target，RA 自己也不校验 `println!` 的格式串（那是 rustc 的事）。
所以这里直接把代码交给 `rustc` / `cargo check`，再自己把行列映射回 qmd。

## 启用方式

`lua/plugins/rust-qmd-check/init.lua` 就是开关，内容如下：

```lua
return {
  {
    "rust-qmd-check", -- 占位名；virtual = true 不会去下载它
    virtual = true,   -- 没有插件目录，只是本地模块
    lazy = false,     -- 启动时注册 autocmd
    config = function()
      require("plugins.rust-qmd-check.checker").setup({
        debounce_ms = 800,
        command = "auto",
        default_edition = "2021",
      })
    end,
  },
}
```

- lazy.nvim 会自动 import `lua/plugins/` 下的 `init.lua`，所以 `init.lua` 里**不需要**
  再写 `dofile` 或 `require`。
- lazy 扫描 `lua/plugins/` 时只认每个子目录的 `init.lua`，所以同目录的
  `checker.lua` 不会被误当成另一个 spec。
- `virtual = true` 表示它不是外部插件：不会被安装，也不会加进 `runtimepath`。
- 暂时不用时，把 `lazy = false` 改成 `enabled = false` 即可。

要求：Neovim 0.10+（用到 `vim.system` / `vim.fs`），系统里有 `rustc`，cargo 模式还需要 `cargo`。

## 工作方式（4 步）

1. **抽取**：把 qmd 里每个 ` ```{rust} ` 块的行原样取出，其它行留空。
   因此生成文件和 qmd 的行号一一对应；`:dep` 行会变成空行。
2. **包裹**：生成文件第 1 行加 `#[allow(dead_code)] fn main() {`，末尾补 `}`。
   这样 evcxr 风格的顶层语句（`let x = 1;`）和教材里的 `fn main() { ... }`
   都能通过编译检查，而且变量在各 chunk 之间仍然共享（和 evcxr 行为一致）。
   行号因此整体 +1，解析诊断时再减回去。
3. **检查**：
   | 文档内容 | 命令 | 典型耗时（实测） |
   |---|---|---|
   | 没有 `:dep` | `rustc --emit=metadata --error-format=json` | 16–21 ms |
   | 有 `:dep` | `cargo check --bin qmd_xxx --message-format=json` | 热态 26–30 ms |

   有 `:dep` 时要求 qmd 位于某个 `Cargo.toml` 工程内；生成的
   `src/bin/qmd_<路径>.rs` 只是临时 target，检查一结束就删除。
   首次 cargo check 如果需要编译依赖，会慢一些；之后走增量缓存。
4. **映射**：解析 JSON 里的 `spans`，行号减 1、列号转成 0 基，
   用 `vim.diagnostic.set` 写到 qmd buffer 的独立命名空间 `rust_qmd_check`。

触发时机：`TextChanged` / `TextChangedI` / `InsertLeave` / `BufWritePost` / `BufEnter`，
统一防抖 300 ms；新的检查开始前会杀掉还没跑完的旧任务。

## 项目侧约定

- 生成文件位于 `src/bin/qmd_*.rs`，检查完即删；建议在项目 `.gitignore` 里加一行
  `src/bin/qmd_*.rs`，防止异常退出时留下的文件被提交。
- 依赖写在哪里：`Cargo.toml` 负责「检查」时的依赖，chunk 里的 `:dep` 负责「渲染」时的依赖。
  两边都写一遍即可（`:dep` 只影响用 rustc 还是 cargo）。
- edition 优先从最近的 `Cargo.toml` 读取，读不到用 `default_edition`（默认 2021）。

## 已知限制

- **顶层 `?`**：被包在返回 `()` 的 `fn main` 里会报错。学习阶段建议写
  `fn run() -> Result<(), Box<dyn std::error::Error>> { ... }` 再调用。
- **多个 `fn main`**：从第二个开始会自动改名为 `__qmd_main_2` 等，避免重名报错
  （只改生成文件，不动 qmd；该行的列号可能有轻微偏移）。
- **重复的顶层 `use`**：只保留第一处，其余变空行，避免重复导入报错。
- **chunk 内不能写 `#![...]`** 这类 crate 级属性，因为它已经被包进函数里。
- **外部 crate 的补全**：仍由 rust-analyzer 提供；它看不到 `Cargo.toml` 时补全较弱，
  但错误检查由这里的 cargo 模式兜底。
- **未使用变量/导入** 等 warning 也会显示，这是有意保留的。
- 与 panache / otter 的诊断互不冲突；它们负责别的事情，命名空间不同。

## 验证是否生效

打开一个含错误的 qmd（例如 `println!("{} {}", x)`），停止输入约 0.3 秒后
应在对应行看到诊断。也可以在命令行里查：

```vim
:lua vim.diagnostic.get(0)
```
