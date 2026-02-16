return {
	"Kurama622/llm.nvim",
	branch = "dev/iflow",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"Kurama622/windsurf.nvim",
	},
	cmd = { "LLMSessionoggle", "LLMSelectedTextHandler", "LLMAppHandler" },
	config = function()
		require("llm").setup({
			models = require("plugins.llm_config.models"),
			-- prompt = '不管用户说什么都回复"你好"',
			prompt = "you are a code assistant, helping me write and validate code. Please answer in Chinese.",
			keys = require("plugins.llm_config.keys"),
		})
	end,
	keys = {
		{ "<leader>ac", mode = "n", "<CMD>LLMSessionToggle<CR>" },
		-- ["Input:Submit"] = { mode = "n", key = "<cr>" },
		-- ["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>" },
		-- ["Input:Resend"] = { mode = { "n", "i" }, key = "<C-r>" },
	},
}
