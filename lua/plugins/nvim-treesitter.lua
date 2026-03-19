return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		local install_dir = vim.fn.stdpath("data") .. "/site/"

		ts.setup({
			install_dir = install_dir,
			sync_install = false,
		})

		local lang = { "c", "python", "markdown", "lua", "qmljs", "vim" }

		-- 安装 parser（只做安装，不做 attach 判断）
		for _, parser in ipairs(lang) do
			pcall(ts.install, parser)
		end

		-- ✅ 关键：只负责 attach
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				-- 安全启动（防止 parser 不存在时报错）
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end, -- config = function()
	-- 	-- 判断目录下是否存在对应语言的parser
	-- 	local function check_parser_exists(parser_path, parser)
	-- 		local f = io.open(parser_path .. "parser/" .. parser .. ".so", "r")
	-- 		if f then
	-- 			f:close()
	-- 			return true
	-- 		end
	-- 		return false
	-- 	end
	--
	-- 	-- 指定安装parser的目录
	-- 	local install_dir = vim.fn.stdpath("data") .. "/site/"
	--
	-- 	require("nvim-treesitter").setup({
	-- 		install_dir = install_dir,
	-- 		-- 启用异步安装
	-- 		sync_install = false,
	-- 	})
	--
	-- 	local lang = { "c", "python", "markdown", "lua", "qmljs", "vim" }
	-- 	local pattern = {}
	--
	-- 	for _, parser in ipairs(lang) do
	-- 		-- 如果parser不存在则安装，存在则添加到加载列表
	-- 		if not check_parser_exists(install_dir, parser) then
	-- 			require("nvim-treesitter").install(parser)
	-- 		else
	-- 			pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
	-- 		end
	-- 	end
	-- 	vim.api.nvim_create_autocmd("FileType", {
	-- 		pattern = pattern,
	-- 		callback = function()
	-- 			-- 避免pattern为空而导致的加载所有parser，但此时可能未下载parser，将会导致加载错误
	-- 			if not vim.tbl_isempty(pattern) then
	-- 				vim.treesitter.start()
	-- 			end
	-- 		end,
	-- 	})
	-- end,
}
