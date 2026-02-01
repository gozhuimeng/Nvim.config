return {
	"mason-org/mason.nvim",
	-- event = "VeryLazy",
	opts = {},
	dependencies = {
		"neovim/nvim-lspconfig",
		"mason-org/mason-lspconfig.nvim",
	},

	config = function(_, opts)
		require("mason").setup(opts)
		local registry = require("mason-registry")

		local function setup_lsp(name, config)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			end
			local nvim_lsp = require("mason-lspconfig").get_mappings().package_to_lspconfig[name]
			-- config.capabilities = require("blink.cmp").get_lsp_capabilities()
			config.capabilities = require("cmp_nvim_lsp").default_capabilities()
			config.on_attach = function(client)
				-- client.server_capabilities.signatureHelpProvider = false
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end
			vim.lsp.config(nvim_lsp, config)
			vim.lsp.enable(nvim_lsp)
			-- require("lspconfig")[nvim_lsp].setup(config)
		end

		-- lsp config
		local servers = {
			["lua-language-server"] = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			pyright = {},
			["html-lsp"] = {},
			["css-lsp"] = {},
			["typescript-language-server"] = {},
			["emmet-ls"] = {},
			clangd = {},
			["bash-language-server"] = {
				-- filetypes={"zsh"},
			},
			jdtls = {
				-- Reduce validation/diagnostics churn while typing (jdtls only)
				flags = { debounce_text_changes = 500 }, -- 单位: ms
			},
		}

		for server, config in pairs(servers) do
			setup_lsp(server, config)
		end

		-- vim.cmd("LspStart")
		vim.diagnostic.config({
			underline = true, -- 下划线标识
			-- virtual_text = true,   -- 行后显示错误信息
			virtual_lines = true, -- 显示虚拟行
			update_in_insert = true, -- 插入模式下更新内容
			severity_sort = true, -- 按严重程度排序
		})
	end,
}
