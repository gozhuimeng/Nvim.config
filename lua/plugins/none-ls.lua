return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		local registry = require("mason-registry")

		local function install(name)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			end
		end

		install("stylua")
		install("black")
		install("clang-format")
		install("prettier")
		install("shfmt")
        install("google-java-format")

		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- lua
				null_ls.builtins.formatting.stylua,
				-- python
				null_ls.builtins.formatting.black,
				-- null_ls.builtins.formatting.black.with({
				-- 	command = vim.fn.stdpath("data") .. "/mason/packages/black/venv/bin/black",
				-- }),
				-- C/C++
				null_ls.builtins.formatting.clang_format,
				-- JS/TS
				null_ls.builtins.formatting.prettier,

				-- sh
				null_ls.builtins.formatting.shfmt.with({
					filetypes = { "sh", "bash", "zsh" },
				}),
				-- null_ls.builtins.formatting.shfmt.with({
				-- 	filetypes = { "sh", "zsh" },
				-- 	extra_args = {
				-- 		"-ln",
				-- 		"zsh",
				-- 		"-i",
				-- 		"2",
				-- 	},
				-- }),
			},
		})
	end,
	keys = {
		{
			"<leader>lf",
			vim.lsp.buf.format, -- 格式化
			desc = "格式化",
		},
	},
}
