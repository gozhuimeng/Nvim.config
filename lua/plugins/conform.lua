return {
	"stevearc/conform.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				quarto = { "injected", "prettier" }, -- 先格式化代码块，再格式化 markdown
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				rust = { "rustfmt" },
			},
			formatters = {
				prettier = {
					command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
					options = {
						ext_parsers = {
							qmd = "markdown",
						},
					},
				},
				stylua = {
					command = vim.fn.stdpath("data") .. "/mason/bin/stylua",
				},
				black = {
					command = vim.fn.stdpath("data") .. "/mason/bin/black",
				},
				shfmt = {
					command = vim.fn.stdpath("data") .. "/mason/bin/shfmt",
				},
				["clang-format"] = {
					command = vim.fn.stdpath("data") .. "/mason/bin/clang-format",
				},
			},
		format_on_save = {
			timeout_ms = 2000,
			lsp_fallback = true,
		},
		})

		require("mason-conform").setup({})
	end,
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "格式化",
		},
	},
}
