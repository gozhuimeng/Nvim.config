return {
	"ray-x/lsp_signature.nvim",
	event = "LspAttach",
    -- enabled = false,
	opts = {
		bind = true,
		floating_window = true,

		-- hint_enable = false,
		hint_enable = true,
        hint_prefix = "󰡱 ",
        padding = "  ",

		handlers_opts = {
			border = "rounded",
		},

		max_height = 12,
		max_width = 60,

		toggle_key = nil,
		select_signature_key = nil,
	},
}
