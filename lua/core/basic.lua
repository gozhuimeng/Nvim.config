-- Enable line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor line highlight
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

-- Use four spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- Automatically reload modified file
vim.opt.autoread = true

-- Set "<Leader>"
vim.g.mapleader = " "

-- Set the split direction, but I don't want to do than.
-- vim.opt.splitbelow = true
-- vim.opt.splitright = true

-- The search is not case sensitive,
-- but is case sensitive when it contains uppercase characters.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- search highlight
-- vim.opt.hlsearch = false

-- 保持距离底部和顶部的行数
vim.opt.scrolloff = 8

-- 关闭自动换行
vim.opt.wrap = false

-- 共享系统剪切板
vim.opt.clipboard = "unnamedplus"

-- 拼写检查
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "cjk" }

-- Neovim 远程插件 Python 环境 (molten-nvim 等)
vim.g.python3_host_prog = "/home/meng/.local/bin/pynvim-python"

-- 仓库自带的命令（如 bin/rustfmt-evcxr）加入 PATH，
-- 这样 panache / conform 等子进程可以直接按命令名调用。
local config_bin = vim.fn.stdpath("config") .. "/bin"
if not vim.env.PATH:find(config_bin, 1, true) then
	vim.env.PATH = config_bin .. ":" .. vim.env.PATH
end

-- panache 的用户级配置改用仓库内的 panache/config.toml，
-- 不再依赖 ~/.config/panache/config.toml。
vim.env.PANACHE_CONFIG = vim.fn.stdpath("config") .. "/panache/config.toml"
