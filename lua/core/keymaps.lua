-- Insert mod
vim.keymap.set("i", "jk", "<Esc>", { silent = true })

-- clean search highlight
vim.keymap.set("n", "<C-l>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("i", "<C-l>", "<cmd>nohlsearch<CR>", { silent = true })
