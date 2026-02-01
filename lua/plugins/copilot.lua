return {
	"github/copilot.vim",
	event = "InsertEnter",
    enable = true,
	cmd = "Copilot",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.keymap.set(
			"i",
			"<C-y>",
			-- 'copilot#Accept("\\<CR>")',
			'copilot#Accept("")',
			{ expr = true, replace_keycodes = false, silent = true, desc = "同意copilot建议" }
		)
	end,
}
