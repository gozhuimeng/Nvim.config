return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	opts = {},
	config = function(_, opts)
		require("transparent").setup(opts)
		vim.cmd("TransparentEnable")
	end,
}
