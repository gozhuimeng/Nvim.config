return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		"echasnovski/mini.icons",
		branch = "main",
	},
	opts = {
		-- 设置
		plugins = {
			spelling = {
				enable = true, -- 启用拼写检查
			},
		},
		win = {
			border = "rounded", -- 窗口圆角
		},
		spec = {
			{ "<leader>m", group = "markdow" },
			{ "<leader>h", group = "hop跳转" },
			{ "<leader>l", group = "lsp服务" },
		},
	},
}
