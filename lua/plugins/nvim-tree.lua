return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	keys = {
		{ "<leader>tt", "<cmd>NvimTreeToggle<CR>", desc = "打开/关闭文件树" },
		{ "<leader>tF", "<cmd>NvimTreeFocus<CR>", desc = "聚焦到Nvim-tree" },
		{ "<A-f>", "<cmd>NvimTreeFocus<CR>", desc = "聚焦到Nvim-tree" },
		{ "<leader>to", "<cmd>NvimTreeOpen<CR>", desc = "打开Nvim-tree" },
		{ "<leader>tf", "<cmd>NvimTreeFindFile<CR>", desc = "定位到当前文件" },
	},
	config = function()
		local api = require("nvim-tree.api")

		local function on_attach(bufnr)
			-- 原有配置
			api.config.mappings.default_on_attach(bufnr)

			-- 自定义配置
			vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "展开目录" })
			vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, desc = "收起目录" })
			vim.keymap.set("n", "v", api.node.open.vertical, { buffer = bufnr, desc = "水平分屏打开文件" })
			vim.keymap.set("n", "s", api.node.open.horizontal, { buffer = bufnr, desc = "垂直分屏打开文件" })
		end

		require("nvim-tree").setup({
			actions = {
				open_file = {
					quit_on_open = false, -- 打开文件后自动关闭Nvim-tree
				},
			},
			filters = {
				dotfiles = false, -- 不隐藏点文件
				custom = {}, -- 隐藏目录
			},
			update_focused_file = {
				enable = true, -- 高亮显示当前文件
			},
			git = {
				enable = true, --显示git状态
			},
			diagnostics = {
				enable = true, -- 显示错误/警告标记
			},
			on_attach = on_attach, -- 配置自定义按键
		})
	end,
}
