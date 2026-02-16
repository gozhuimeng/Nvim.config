return {
	{
		name = "iflow/qwen3-coder-plus",
		url = "https://apis.iflow.cn/v1/chat/completions",
		model = "qwen3-coder-plus",
		api_type = "openai",
		fetch_key = function()
			return os.getenv("IFLOW_API_KEY")
		end,
	},
	{
		name = "Siliconflow/Qwen2.5-Coder-7B-Instruct",
		url = "https://api.siliconflow.cn/v1/chat/completions",
		model = "Qwen/Qwen2.5-Coder-7B-Instruct",
		api_type = "openai",
		fetch_key = function()
			return os.getenv("SILICONFLOW_API_KEY")
		end,
	},
	{
		name = "Ollama-openai/Qwen2.5-Coder-0.5b-Instruct",
		url = "http://192.168.1.8:11434/v1/chat/completions",
		model = "qwen2.5-coder:0.5b-instruct-q8_0",
		api_type = "openai",
		fetch_key = "None",
	},
	{
		name = "Ollama/Qwen2.5-Coder-0.5b-Instruct",
		url = "http://192.168.1.8:11434/api/chat",
		model = "qwen2.5-coder:0.5b-instruct-q8_0",
		api_type = "ollama",
		fetch_key = "None",
	},
}
