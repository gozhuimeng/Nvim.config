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
		}

		for server, config in pairs(servers) do
			setup_lsp(server, config)
		end

		-- vim.cmd("LspStart")
		vim.diagnostic.config({
			underline = true,
			virtual_text = true,
			-- virtual_lines = true,
			update_in_insert = true,
		})
	end,
}
