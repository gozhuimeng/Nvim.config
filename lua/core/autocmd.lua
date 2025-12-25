-- 修改系统输入法，此方案只在linux fcitx中生效
local is_enable = true

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		if is_enable then
			vim.fn.system("fcitx5-remote -c") -- 切换至英文模式
		end
	end,
	desc = "退出插入模式的同时切换至英文输入法",
})
