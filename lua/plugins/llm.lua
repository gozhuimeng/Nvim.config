return {
	"Kurama622/llm.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"Kurama622/windsurf.nvim",
	},
	cmd = { "LLMSessionoggle", "LLMSelectedTextHandler", "LLMAppHandler" },
	config = function()
		require("llm").setup({
			models = require("plugins.llm_config.models").models_list,
			prompt = "you are a code assistant, helping me write and validate code. Please answer in Chinese.",
			keys = require("plugins.llm_config.keys").chat_key,
			app_handler = require("plugins.llm_config.app_handler"),
		})
	end,
	keys = require("plugins.llm_config.keys").handle_key,
}
