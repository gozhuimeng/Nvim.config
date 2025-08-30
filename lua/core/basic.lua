-- Enable line numers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor line highlight
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

-- Use four spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- Automatically reload modifird file
vim.opt.autoread = true

-- Set "<Leader>"
vim.g.mapleader = " "

-- Set the split direction, but I don't want to do than.
-- vim.opt.splitbelow = true
-- vim.opt.splitright = ture

-- The search is not case sensitive, 
-- but is case sensitive when it contains uppercase characters.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- search highlight
-- vim.opt.hlsearch = false
