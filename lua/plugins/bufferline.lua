return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "文件树",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		})
		vim.keymap.set("n", "<A-l>", "<CMD>BufferLineCycleNext<CR>", {
			desc = "切换下一个buffer",
		})
		vim.keymap.set("n", "<A-h>", "<CMD>BufferLineCyclePrev<CR>", {
			desc = "切换上一个buffer",
		})
		vim.keymap.set("n", "<A-C>", "<CMD>BufferLinePickClose<CR>", {
			desc = "选择关闭一个buffer",
		})
		vim.keymap.set("n", "<A-c>", function()
			-- 判断buffer是否保存
			if vim.api.nvim_get_option_value("modified", { buf = 0 }) then
				vim.notify(
					"当前缓冲区有未保存的修改，请先保存在关闭",
					vim.log.levels.WARN,
					{ title = "Buffer 未保存" }
				)
				return
			end

			-- 记录当前buffer
			local current = vim.api.nvim_get_current_buf()

			-- 查询并筛选可用buffer
			local buffers = vim.tbl_filter(function(buf)
				-- 判断是否为当前buffer
				if buf == current then
					return false
				end
				-- 判断是否为可用buffer
				if not vim.api.nvim_buf_is_loaded(buf) then
					return false
				end
				-- 排除终端、nvim-tree等的buffer
				local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
				return buftype == ""
			end, vim.api.nvim_list_bufs())

			-- 判断是否还有其他buffer
			if #buffers > 0 then
				vim.cmd("bprevious")
				vim.cmd("bdelete #")
			else
				vim.cmd("enew")
				vim.cmd("bdelete" .. current)
                vim.cmd("NvimTreeFocus")
			end
		end, {
			desc = "关闭当前buffer",
		})
	end,
}
