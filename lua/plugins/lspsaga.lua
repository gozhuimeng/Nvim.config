return {
	"nvimdev/lspsaga.nvim",
	cmd = "Lspsaga",
	opts = {
		-- 关闭自动灯泡提示：它会在光标移动时反复放置/移除 2 格宽的 sign，
		-- 导致 signcolumn 宽度跳变、文本左右抖动。
		-- 需要 code action 时手动按 <leader>lc 即可，功能完全独立不受影响。
		lightbulb = {
			enable = false,
		},
		finder = {
			keys = {
				toggle_or_open = "<CR>", -- 修改查找时跳转到对应位置的按键，默认是O
			},
		},
	},
	keys = {
		{ "<leader>lr", ":Lspsaga rename<CR>", desc = "重命名" },
		{ "<leader>lc", ":Lspsaga code_action<CR>", desc = "为错误提供建议" },
		{ "<leader>ld", ":Lspsaga goto_definition<CR>", desc = "跳转到定义" },
		{ "<leader>lh", ":Lspsaga hover_doc<CR>", desc = "显示文档" },
		{ "<leader>lR", ":Lspsaga finder<CR>", desc = "查找引用" },
		{ "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>", desc = "跳转到下一个诊断" },
		{ "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>", desc = "跳转到上一个诊断" },
	},
}
