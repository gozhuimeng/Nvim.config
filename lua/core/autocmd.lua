-- 修改系统输入法，此方案只在linux fcitx中生效
if vim.fn.executable("fcitx5-remote") == 1 then
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			vim.fn.system("fcitx5-remote -c") -- 切换至英文模式
		end,
		desc = "退出插入模式的同时切换至英文输入法",
	})
end

-- 使用nvim打开目录的时候是否使用Nvim-tree替代原有的netrw
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local path = vim.fn.argv(0)
		if path ~= "" and vim.fn.isdirectory(path) == 1 then
			vim.cmd("bd")
			require("nvim-tree.api").tree.open()
		end
	end,
})
