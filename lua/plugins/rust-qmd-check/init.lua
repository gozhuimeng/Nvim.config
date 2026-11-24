-- qmd 内嵌 Rust 代码的检查器（本地模块，不是外部插件）。
--
-- 目录结构：
--   init.lua      -- 这个 spec，负责在 lazy 里注册并调用 setup()
--   checker.lua   -- 检查器实现（rustc / cargo check + 诊断映射）
--   README.md     -- 使用说明
--
-- lazy.nvim 的 import 只认目录里的 init.lua，所以 checker.lua 不会被当成 spec。
-- virtual = true 表示没有插件仓库：不会被安装，也不会加进 runtimepath。
return {
	{
		"rust-qmd-check", -- 占位名；virtual = true 不会去下载它
		virtual = true,
		lazy = false, -- 启动时注册 FileType autocmd，打开 qmd 即可生效
		config = function()
			require("plugins.rust-qmd-check.checker").setup({
				debounce_ms = 800, -- 停止输入多久后检查（毫秒）
				command = "auto", -- "auto" | "rustc" | "cargo"
				default_edition = "2021", -- 没有 Cargo.toml 时用哪个 edition
			})
		end,
	},
}
