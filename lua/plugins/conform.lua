return {
	"stevearc/conform.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {},
	config = function()
		local ignore_override_patterns = {
			"%.opencode/",
		}
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
				quarto = { "panache" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				rust = { "rustfmt" },
				sql = { "sql_formatter" }, -- mason 包 sql-formatter
				toml = { "taplo" },
			},
			formatters = {
				prettier = {
					command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
					args = function(self, ctx)
						local args = { "--stdin-filepath", ctx.filename }
						for _, pat in ipairs(ignore_override_patterns) do
							if ctx.filename:find(pat) then
								table.insert(args, 1, "--ignore-path")
								table.insert(args, 2, "/dev/null")
							end
						end
						-- vim.notify("conform prettier args: " .. vim.inspect(args), vim.log.levels.WARN)
						return args
					end,
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
				sql_formatter = {
					command = vim.fn.stdpath("data") .. "/mason/bin/sql-formatter",
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
