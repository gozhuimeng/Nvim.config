return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		-- "rafamadriz/friendly-snippets",
	},
	-- enabled = false,
	event = "VeryLazy",
	opts = {
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		keymap = {
			preset = "super-tab",
		},
		sources = {
			default = { "path", "snippets", "buffer", "lsp" },
		},
		snippets = {
			preset = "luasnip",
		},
		cmdline = {
			sources = function()
				local cmd_type = vim.fn.getcmdtype()
				if cmd_type == "/" then
					return { "buffer" }
				end
				if cmd_type == ":" then
					return { "cmdline" }
				end
				return {}
			end,
			keymap = {
				preset = "super-tab",
			},
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
	},
}
