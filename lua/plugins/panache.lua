return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		local function ensure_panache()
			-- vim.notify("config 阶段测试", vim.log.levels.INFO)
			if vim.fn.exepath("panache") ~= "" then
				return
			end

			local ok, registry = pcall(require, "mason-registry")
			if not ok then
				vim.notify(
					"panache 未安装，且无法加载 mason-registry。请手动 :MasonInstall panache",
					vim.log.levels.WARN
				)
				return
			end

			registry.refresh(function()
				local pkg_ok, pkg = pcall(function()
					return registry.get_package("panache")
				end)
				if not pkg_ok or not pkg then
					vim.notify(
						"panache 不在 Mason registry 中。请手动安装或检查网络。",
						vim.log.levels.WARN
					)
					return
				end
				if not pkg:is_installed() then
					vim.notify("正在通过 Mason 安装 panache ...", vim.log.levels.INFO)
					pkg:install()
				end
			end)
		end

		vim.defer_fn(ensure_panache, 500)

		vim.lsp.config("panache", {
			cmd = { "panache", "lsp" },
			filetypes = { "quarto", "markdown", "rmarkdown" },
			root_markers = { ".panache.toml", "panache.toml", ".git" },
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
		vim.lsp.enable("panache")
	end,
}
