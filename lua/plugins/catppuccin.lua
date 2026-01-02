return {
	"catppuccin/nvim",
	opts = {
		style = "Mocha",
		transparent_background = true,
	},
	-- enabled = false,
	priority = 1000,
	name = "catppuccin",
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}
