return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.icons",
	},
	ft = { "markdown", "llm", "quarto" },

	config = function()
		require("render-markdown").setup({
			restart_highlighter = true,
			heading = {
				enabled = true,
				sign = false,
				position = "overlay",
				icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				signs = { "󰫎 " },
				width = "block",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = false,
				border_virtual = false,
				border_prefix = false,
				above = "▄",
				below = "▀",
				backgrounds = {},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH2",
					"RenderMarkdownH3",
					"RenderMarkdownH4",
					"RenderMarkdownH5",
					"RenderMarkdownH6",
				},
			},
			dash = {
				enabled = true,
				icon = "─",
				width = 0.5,
				left_margin = 0.5,
				highlight = "RenderMarkdownDash",
			},
			code = {
				language_icon = true,
				language_name = true,
			},
		})
	end,
}
