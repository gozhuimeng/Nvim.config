return {
	"folke/tokyonight.nvim",
	opts = {
		style = "moon",
	},
	enabled = false,
	config = function(_, opts)
		require("tokyonight").setup(opts)
		-- vim.cmd("colorscheme tokyonight")
	end,
}
