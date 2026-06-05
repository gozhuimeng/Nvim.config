return {
	"Kurama622/llm.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"Kurama622/windsurf.nvim",
	},
	cmd = { "LLMSessionoggle", "LLMSelectedTextHandler", "LLMAppHandler" },
	enable = false,
	config = function()
		require("llm").setup({
			models = require("plugins.llm_config.models").models_list,
			prompt = "you are a code assistant, helping me write and validate code. Please answer in Chinese.",
			keys = require("plugins.llm_config.keys").chat_key,
			app_handler = vim.tbl_deep_extend("force", require("plugins.llm_config.app_handler"), {
				-- 代码补全 - 放在 app_handler 中以便自动触发
				Completion = {
					handler = "completion_handler",
					opts = {
						-- 使用本地模型 qwen3.5-0.8b
						url = "http://localhost:1234/v1/completions",
						model = "qwen3.5-0.8b",
						api_type = "openai",
						fetch_key = "NONE",
						disable_url_path_completion = true,

						n_completions = 3,
						context_window = 512,
						max_tokens = 256,
						auto_trigger = true,
						only_trigger_by_keywords = false,
						style = "virtual_text",
						timeout = 30,
						debounce = 400,
						throttle = 1000,

						-- 虚拟文本按键配置
						keymap = {
							virtual_text = {
								accept = {
									mode = "i",
									keys = "<A-Tab>",
								},
								next = {
									mode = "i",
									keys = "<A-n>",
								},
								prev = {
									mode = "i",
									keys = "<A-p>",
								},
								toggle = {
									mode = "n",
									keys = "<leader>cp",
								},
							},
						},
					},
				},
			}),
		})
	end,
	keys = require("plugins.llm_config.keys").handle_key,
}
