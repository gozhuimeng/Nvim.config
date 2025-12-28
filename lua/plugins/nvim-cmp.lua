return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local types = require("cmp.types")

		cmp.setup({
			-- 使用luasinp展开snippet
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- 按键配置
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					elseif luasnip.expand_or_jumpable() then -- 使用tab在snippet中跳转
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then -- 使用S-Tab回到snippet上一处输入
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- 上下选择补全项
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- 关闭补全菜单
				["<C-e>"] = cmp.mapping.abort(),

				-- 回车确认补全
				-- ["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),

			-- 补全来源（顺序很重要）
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry)
						return entry:get_kind() ~= types.lsp.CompletionItemKind.Snippet
					end,
				}, -- 禁用lsp提供的 snippet
				{ name = "luasnip" }, -- 启用 luasnip
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
	end,
}
