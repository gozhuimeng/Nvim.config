return {
	"catppuccin/nvim",
	opts = {
		style = "Mocha",
	},
	priority = 1000,
	name = "catppuccin",
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}
