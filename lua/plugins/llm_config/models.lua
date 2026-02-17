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
	ollama = {
		name = "Ollama-openai/Qwen2.5-Coder-0.5b-Instruct",
		url = "http://192.168.1.8:11434/v1/chat/completions",
		model = "qwen2.5-coder:0.5b-instruct-q8_0",
		api_type = "openai",
		fetch_key = "None",
	},
	ollama2 = {
		name = "Ollama/Qwen2.5-Coder-0.5b-Instruct",
		url = "http://192.168.1.8:11434/api/chat",
		model = "qwen2.5-coder:0.5b-instruct-q8_0",
		api_type = "ollama",
		fetch_key = "None",
	},
}

local function get_unname_config(models_tables)
	local result_models_list = {}
	for _, value in pairs(models_tables) do
		table.insert(result_models_list, value)
	end
	return result_models_list
end

return {
	models_list = get_unname_config(models),
	models = models,
}
