return {
	"alexpasmantier/tv.nvim",
	config = function()
		local h = require("tv").handlers
		require("tv").setup({
			window = {
				width = 0.8,
				height = 0.8,
				border = "rounded",
				title = "television finder",
				title_pos = "center",
			},
			channels = {
				files = {
					keybinding = "<leader>ff",
					handlers = {
						["<CR>"] = h.open_as_files,
						["<C-v>"] = h.open_in_vsplit,
						["<C-s>"] = h.open_in_split,
						["<C-t>"] = h.open_in_tab,
						["<C-q>"] = h.send_to_quickfix,
						["<C-y>"] = h.copy_to_clipboard,
					},
				},
				text = {
					keybinding = "<leader>ft",
					handlers = {
						["<CR>"] = h.open_at_line,
						["<C-v>"] = h.open_in_vsplit,
						["<C-s>"] = h.open_in_split,
						["<C-t>"] = h.open_in_tab,
						["<C-q>"] = h.send_to_quickfix,
						["<C-y>"] = h.copy_to_clipboard,
					},
				},
				["git-log"] = {
					keybinding = "<leader>fgl",
					handlers = {
						["<CR>"] = h.execute_shell_command("git show {}"),
						["<C-y>"] = h.copy_to_clipboard, -- 复制哈希
					},
				},
				["env"] = {
					keybinding = "<leader>fe",
					handlers = {
						["<CR>"] = h.insert_at_cursor,
						["<C-l>"] = h.insert_on_new_line,
						["<C-y>"] = h.copy_to_clipboard,
					},
				},
			},
			global_keybindings = {
				channels = "<leader>fo",
			},
			quickfix = {
				auto_open = true,
			},
		})
	end,
}
