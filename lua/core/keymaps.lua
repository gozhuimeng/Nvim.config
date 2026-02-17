-- Insert mod
vim.keymap.set("i", "jk", "<Esc>", { silent = true, desc = "退出i模式" })

-- clean search highlight
vim.keymap.set("n", "<C-l>", ":nohlsearch<CR>", { silent = true, desc = "取消搜索高亮" })
vim.keymap.set("i", "<C-l>", "<cmd>nohlsearch<CR>", { silent = true, desc = "取消搜索高亮" })

-- temporary
vim.keymap.set({"i","n"},"<C-q>","<cmd>luafile %<CR>",{silent=true,desc = "执行当前lua文件(临时)"})
