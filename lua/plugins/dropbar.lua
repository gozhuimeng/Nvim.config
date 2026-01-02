return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	config = function()
		local dropbar_api = require("dropbar.api")
		vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "激活符号选择" })
		vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "跳转到当前上下文开始处" })
		vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "选择下一个上下文" })
	end,
}
