return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	enabled = false,
	-- 适应不同平台
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	version = false,
	dependencies = {
		-- 必须
		"nvim-lua/plenary.nvim", -- lua 工具函数
		"MunifTanjim/nui.nvim", -- UI 框架
		"nvim-treesitter/nvim-treesitter", -- 代码上下文分析

		-- 建议
		"stevearc/dressing.nvim", -- 美化输入框
		"nvim-tree/nvim-web-devicons", -- 小图标

		-- 可选
		{
			"HakonHarnes/img-clip.nvim", -- 支持图片粘贴，实现多模态
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},

		{
			"MeanderingProgrammer/render-markdown.nvim", -- markdown 解析优化
			opts = {
				file_types = { "Avante" },
			},
			ft = { "Avante" },
		},

		-- 不需要
		-- "zbirenbaum/copilot.lua"
	},

	-- config
	config = function()
		require("avante").setup({
			provider = "qwencoder",
			providers = {
				qwencoder = {
					-- disable function/tool calling if the model does not support it
					disable_tools = true,
					__inherited_from = "openai",
					api_key_name = "SILICONFLOW_API_KEY",
					endpoint = "https://api.siliconflow.cn/v1",
					model = "Qwen/Qwen2.5-Coder-7B-Instruct",
					timeout = 30000, -- 超时时间(ms)
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 16384,
					},
				},
				deepseek = {
					disable_tools = true,
					__inherited_from = "openai",
					api_key_name = "SILICONFLOW_API_KEY",
					endpoint = "https://api.siliconflow.cn/v1",
					model = "deepseek-ai/DeepSeek-R1-0528-Qwen3-8B",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 16384,
					},
				},
				qwen3 = {
					disable_tools = true,
					__inherited_from = "openai",
					api_key_name = "SILICONFLOW_API_KEY",
					endpoint = "https://api.siliconflow.cn/v1",
					model = "Qwen/Qwen3-8B",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 16384,
					},
				},
				glmz1 = {
					disable_tools = true,
					__inherited_from = "openai",
					api_key_name = "SILICONFLOW_API_KEY",
					endpoint = "https://api.siliconflow.cn/v1",
					model = "THUDM/GLM-Z1-9B-0414",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 16384,
					},
				},
			},
		})

		-- 中文 keymap 绑定（覆盖默认英文 desc）
		-- vim.keymap.set("n", "<leader>aa", function()
		-- 	require("avante.api").toggle()
		-- end, { desc = "打开 Avante 聊天窗口" })
		-- vim.keymap.set("n", "<leader>ac", function()
		-- 	require("avante.api").explain()
		-- end, { desc = "代码解释/生成/修改" })
		-- vim.keymap.set("n", "<leader>ar", function()
		-- 	require("avante.api").retry()
		-- end, { desc = "重试上一次请求" })
		-- vim.keymap.set("n", "<leader>as", function()
		-- 	require("avante.api").stop()
		-- end, { desc = "停止当前请求" })
		-- vim.keymap.set("n", "<leader>ad", function()
		-- 	require("avante.api").apply_diff()
		-- end, { desc = "应用 AI 建议的 diff" })
		-- vim.keymap.set("n", "<leader>az", function()
		-- 	require("avante.api").zen_mode()
		-- end, { desc = "进入 Zen 模式" })
		-- vim.keymap.set("n", "<leader>ap", function()
		-- 	require("avante.api").project_instructions()
		-- end, { desc = "项目指令（avante.md）" })
		-- vim.keymap.set("n", "<leader>al", function()
		-- 	require("avante.api").show_log()
		-- end, { desc = "查看聊天日志" })
		-- vim.keymap.set("n", "<leader>aq", function()
		-- 	require("avante.api").close()
		-- end, { desc = "关闭 Avante 聊天窗口" })
	end,
}
