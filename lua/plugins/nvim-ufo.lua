return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
        "nvim-treesitter/nvim-treesitter"
	},
	config = function()
		vim.o.foldcolumn = "1" -- '0'会隐藏折叠列
		vim.o.foldlevel = 99 -- 折叠深度
		vim.o.foldlevelstart = 99 --启动时打开的最大折叠级别
		vim.o.foldenable = true -- 启用折叠

		vim.keymap.set("n", "zr", require("ufo").openAllFolds, { desc = "展开内容" })
		vim.keymap.set("n", "zm", require("ufo").closeAllFolds, { desc = "折叠内容" })

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }  -- 使用treesitter提供折叠
			end,
		})
	end,
}
