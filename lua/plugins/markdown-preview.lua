return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- build = "cd app && npm install",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	config = function()
		-- vim.g.mkdp_auto_start = 1  -- 打开markdown的时候自动启用预览
		vim.g.mkdp_auto_close = 1 -- 关闭markdown的时候自动关闭预览
		vim.g.mkdp_refresh_show = 0 -- 实时刷新(0 = 快速刷新)
		vim.g.mkdp_open_to_the_world = 1 -- 允许局域网访问
	end,
	keys = {
		{
			"<leader>mp",
			":MarkdownPreviewToggle<CR>",
			desc = "启用预览窗口",
			mode = { "n" },
			silent = true,
		},
		-- { "<C-m>p", "<CMD>MarkdownPreviewToggle<CR>", desc = "启用预览窗口", mode = { "i" }, silent = true },  -- 该快捷键会导致回车卡顿，暂时未知原因，故注释
		{
			"<leader>mP",
			":MarkdownPreview<CR>",
			desc = "强制启用预览窗口",
			mode = { "n" },
			silent = true,
		},
		{
			"<leader>ms",
			":MarkdownPreviewStop<CR>",
			desc = "停用预览窗口",
			mode = { "n" },
			silent = true,
		},
		{ "<leader>mr", ":MarkdownPreviewRefresh<CR>", desc = "重新窗口", mode = { "n" }, silent = true },
	},
}
