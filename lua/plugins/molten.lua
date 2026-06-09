return {
	-- molten-nvim: Jupyter 内核交互插件
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			-- 图像渲染使用 image.nvim
			vim.g.molten_image_provider = "image.nvim"

			-- 输出窗口配置
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = true

			-- 虚拟文本输出（在代码下方显示输出）
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true

			-- 自动弹出图像查看器
			vim.g.molten_auto_image_popup = false

			-- 输出窗口边框
			vim.g.molten_output_win_border = { "", "━", "", "" }
		end,
	},

	-- image.nvim: 图像渲染支持
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},

	-- molten-nvim 键位映射
	{
		"benlubas/molten-nvim",
		keys = {
			-- 初始化内核
			{ "<leader>mi", ":MoltenInit<CR>", silent = true, desc = "初始化内核" },

			-- 执行代码
			{ "<leader>me", ":MoltenEvaluateOperator<CR>", silent = true, desc = "执行选中代码" },
			{ "<leader>ml", ":MoltenEvaluateLine<CR>", silent = true, desc = "执行当前行" },
			{ "<leader>mr", ":MoltenReevaluateCell<CR>", silent = true, desc = "重新执行单元格" },
			{ "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", silent = true, desc = "执行可视选区" },

			-- 输出窗口管理
			{ "<leader>mo", ":noautocmd MoltenEnterOutput<CR>", silent = true, desc = "打开输出窗口" },
			{ "<leader>mh", ":MoltenHideOutput<CR>", silent = true, desc = "隐藏输出窗口" },

			-- 单元格管理
			{ "<leader>md", ":MoltenDelete<CR>", silent = true, desc = "删除单元格" },
		},
	},
}
