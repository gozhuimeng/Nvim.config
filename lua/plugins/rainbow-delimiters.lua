return {
	"HiPhish/rainbow-delimiters.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = "rainbow-delimiters.strategy.global", -- 全局策略
				-- lua = "rainbow-delimiters.strategy.local", -- Lua 选中区域括号高亮
			},
			query = {
				[""] = "rainbow-delimiters", -- 默认查询
				lua = "rainbow-blocks", -- Lua 使用不同查询
			},
			priority = {
				[""] = 110, -- 默认优先级
				lua = 210, -- Lua 文件优先级较高
			},
			highlight = {
				"RainbowDelimiterRed", -- 红色
				"RainbowDelimiterYellow", -- 黄色
				"RainbowDelimiterBlue", -- 蓝色
				"RainbowDelimiterOrange", -- 橙色
				"RainbowDelimiterGreen", -- 绿色
				"RainbowDelimiterViolet", -- 紫色
				"RainbowDelimiterCyan", -- 青色
			},
			show_trailing = true, -- 显示括号后的内容
			max_file_lines = 1000, -- 超过1000行的文件禁用
		})
	end,
}
