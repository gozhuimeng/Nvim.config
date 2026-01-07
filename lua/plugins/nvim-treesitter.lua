return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- 安装的解析器
			ensure_installed = { "c", "python", "lua", "markdown", "markdown_inline", "qmljs" },

			-- 启用异步安装
			sync_install = false,
			-- 启用自动安装（需要有treesitter cli)
			auto_install = true,
			-- 不安装的解析器
			ignore_install = {},
			-- 启用高亮
			highlight = {
				enable = true,
				-- 禁用高亮的文件类型
				-- disable = {},
				-- 自定义函数
				-- 对于大文件禁用高亮
				disable = function(lang, buf)
					local max_filesize = 1024 * 1024 -- 1MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
