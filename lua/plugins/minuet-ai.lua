return {
	"milanglacier/minuet-ai.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- event = "VeryLazy",
	config = function()
		require("minuet").setup({
			-- 行内虚拟文本
			virtualtext = {
				auto_trigger_ft = { "c", "cpp", "h", "python", "java", "html", "js", "css" },
				keymap = {
					accept = "<A-A>",
					accept_line = "<A-a>",
					accept_n_lines = "<A-z>",
					prev = "<A-[>",
					next = "<A-]>",
					dismiss = "<A-e>",
				},
			},
			-- 模型配置
			provider = "openai_compatible", -- 使用openai协议
			request_timeout = 5.0, -- 超时时间(s)
			throttle = 800, -- 请求最小时间间隔(ms)
			debounce = 400, -- 停止输入后多长时间发送请求(ms)
			-- 模型选择
			provider_options = {
				openai_compatible = {
					name = "SiliconFlow_Qwen", -- 模型名称，用于日志显示
					api_key = function()
						return os.getenv("SILICONFLOW_API_KEY") -- API_KEY 存放于环境变量中
					end,
					end_point = "https://api.siliconflow.cn/v1/chat/completions",
					model = "Qwen/Qwen2.5-Coder-7B-Instruct",

					-- 参数控制
					optional = {
						max_tokens = 256, -- 最大token
						temperature = 0.4, -- 越低发散性越小
						top_p = 0.95, -- 控制采样范围
					},
				},
			},
		})
	end,
}
