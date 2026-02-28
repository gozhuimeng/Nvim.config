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

-- spell
-- spellfile's path
local base_dir = vim.fn.stdpath("config") .. "/lua/core/spell/"

-- Auto create spellfile for different filetype
local spell_group = vim.api.nvim_create_augroup("AutoSpell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = spell_group,
	pattern = "*",
	callback = function(args)
		local ft = args.match

		local ft_spell = base_dir .. ft .. ".utf-8.add"
		local global_spell = base_dir .. "global.utf-8.add"

		vim.fn.mkdir(base_dir, "p")

		vim.opt_local.spell = true
		vim.opt_local.spellfile = { ft_spell, global_spell }
	end,
})

-- Check if the binary file exists, and compile the nonexistent file
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, file in ipairs(vim.fn.globpath(base_dir, "*.add", true, true)) do
			local spl = file .. ".spl"
			if vim.fn.filereadable(file) == 1 and vim.fn.filereadable(spl) == 0 then
				vim.cmd("silent mkspell!" .. file)
			end
		end
	end,
})

-- create cmd for compiling all spell files.
vim.api.nvim_create_user_command("RecompileAllSpell", function()
	for _, f in ipairs(vim.fn.globpath(base_dir, "*.add", true, true)) do
		vim.cmd("mkspell!" .. f)
	end
	print("All spell compiled!")
end, { desc = "Recompile all spell files" })
