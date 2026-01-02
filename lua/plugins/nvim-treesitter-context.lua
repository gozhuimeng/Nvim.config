return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("treesitter-context").setup({
			enable = true,
			multiwindow = true, -- 启用多窗口
			max_lines = 0, -- 上下文显示最大行数，小于0表示没有限制
			min_window_height = 0, -- 设置窗口的最小高度，小于0表示没有限制
			line_numbers = true, -- 显示行号
			multiline_threshold = 20, -- 如果上下文超过该值，则显示上下文
			trim_scope = "outer", -- 超过时丢弃上下文行，可选inner和outer
			mode = "cursor", -- 基于光标计算上下文
			spearator = "-", -- 使用 - 作为上下文和内容的分割符
			zindex = 30, -- 上下文窗口的Z-index
		})
	end,
	vim.keymap.set("n", "[C", function()
		require("treesitter-context").go_to_context(vim.count1)
	end, { silent = true, desc = "跳转到上一个上下文窗口" }),
}
