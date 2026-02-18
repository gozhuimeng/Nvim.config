local models = {
	iflow = {
		name = "iflow/qwen3-coder-plus",
		url = "https://apis.iflow.cn/v1/chat/completions",
		model = "qwen3-coder-plus",
		api_type = "openai",
		fetch_key = function()
			return os.getenv("IFLOW_API_KEY")
		end,
	},
	siliconflow = {
		name = "Siliconflow/Qwen2.5-Coder-7B-Instruct",
		url = "https://api.siliconflow.cn/v1/chat/completions",
		model = "Qwen/Qwen2.5-Coder-7B-Instruct",
		api_type = "openai",
		fetch_key = function()
			return os.getenv("SILICONFLOW_API_KEY")
		end,
	},
	ollama_qwen2_5_coder_0_5b = {
		name = "Ollama/Qwen2.5-Coder:0.5b-Instruct",
		url = "http://192.168.1.8:11434/v1/chat/completions",
		model = "qwen2.5-coder:0.5b-instruct-q8_0",
		api_type = "openai",
		fetch_key = "None",
	},
	ollama_qwen3_0_6b = {
		name = "Ollama/Qwen3:0.6b",
		url = "http://192.168.1.8:11434/api/chat",
		model = "qwen3:0.6b",
		api_type = "ollama",
		fetch_key = "None",
		keep_alive = "1m",
	},
}

local models_key_name = { "iflow", "siliconflow", "ollama_qwen2_5_coder_0_5b", "ollama_qwen3_0_6b" }

local function get_unname_config(models_tables)
	local result_models_list = {}
	for _, key in ipairs(models_key_name) do
		if models_tables[key] then
			table.insert(result_models_list, models_tables[key])
		end
	end
	return result_models_list
end

return {
	models_list = get_unname_config(models),
	models = models,
}
