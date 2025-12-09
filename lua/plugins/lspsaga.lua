return {
	"nvimdev/lspsaga.nvim",
	cmd = "Lspsaga",
	opts = {
		finder = {
			keys = {
				toggle_or_open = "<CR>",  -- 修改查找时跳转到对应位置的按键，默认是O
			},
		},
	},
	keys = {
		{ "<leader>lr", ":Lspsaga rename<CR>", desc = "重命名" }, -- 重命名
		{ "<leader>lc", ":Lspsaga code_action<CR>" },
		{ "<leader>ld", ":Lspsaga goto_definition<CR>" ,desc="跳转到定义"}, -- 跳转至定义
		{ "<leader>lh", ":Lspsaga hover_doc<CR>",desc="显示文档" }, -- 展开注释
		{ "<leader>lR", ":Lspsaga finder<CR>" ,desc="查找引用"}, -- 查找器
		{ "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>", desc="跳转到下一个诊断" }, -- 跳转到下一个诊断
		{ "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>",desc="跳转到上一个诊断" }, -- 跳转到上一个诊断
	},
}
