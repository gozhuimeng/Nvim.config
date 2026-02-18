local tools = require("llm.tools")
local prompt = require("plugins.llm_config.prompt")
local models = require("plugins.llm_config.models").models

local base_opt = {
	-- accept = {
	-- 	mapping = {
	-- 		mode = "n",
	-- 		keys = { "y", "Y" },
	-- 	},
	-- 	action = nil,
	-- },
	-- reject = {
	-- 	mapping = {
	-- 		mode = "n",
	-- 		keys = { "n", "N" },
	-- 	},
	-- 	action = nil,
	-- },
	-- close = {
	-- 	mapping = {
	-- 		mode = "n",
	-- 		keys = { "q", "Q" },
	-- 	},
	-- 	action = nil,
	-- },

	exit_on_move = true,
	enter_flexible_window = false,
	enable_cword_context = false,
}

local function get_opts(base_opts, model_opts)
	for k, v in pairs(model_opts) do
		base_opts[k] = v
	end

	return base_opts
end

return {
	WordTranslateCloud2E = {
		handler = tools.flexi_handler,
		prompt = prompt.translate_to_english,
		opts = get_opts(base_opt, models.iflow),
	},
	WordTranslateLocal2E = {
		handler = tools.flexi_handler,
		prompt = prompt.translate_to_english,
		opts = get_opts(base_opt, models.ollama_qwen2_5_coder_0_5b),
	},
	WordTranslateCloud2C = {
		handler = tools.flexi_handler,
		prompt = prompt.translate_to_chinese,
		opts = get_opts(base_opt, models.iflow),
	},
	WordTranslateLocal2C = {
		handler = tools.flexi_handler,
		prompt = prompt.translate_to_chinese,
		opts = get_opts(base_opt, models.ollama_qwen2_5_coder_0_5b),
	},
}
