return {
	chat_key = {
		["Input:Submit"] = { mode = { "n", "i" }, key = "<C-cr>" },
		["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>" },
		["Input:Resend"] = { mode = { "n", "i" }, key = "<C-r>" },
		["Session:New"] = { mode = { "n", "i" }, key = "<C-n>" },
	},
	handle_key = {
		{ "<leader>ao", mode = "n", "<CMD>LLMSessionToggle<CR>", desc = "Open the AI chat" },
		{
			"<leader>ace",
			mode = { "x", "n" },
			"<CMD>LLMAppHandler WordTranslateCloud2E<CR>",
			desc = "translate to english(cloud) ",
		},
		{
			"<leader>acc",
			mode = { "x", "n" },
			"<CMD>LLMAppHandler WordTranslateCloud2C<CR>",
			desc = "translate to chinese(cloud) ",
		},
		{
			"<leader>ale",
			mode = { "x", "n" },
			"<CMD>LLMAppHandler WordTranslateLocal2E<CR>",
			desc = "translate to english(local) ",
		},
		{
			"<leader>alc",
			mode = { "x", "n" },
			"<CMD>LLMAppHandler WordTranslateLocal2C<CR>",
			desc = "translate to chinese(local) ",
		},
	},
}
