return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdLineEnter" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
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

			-- formatting 格式
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind_icons = {
						Text = "󰉿", -- 普通文本（很少用，偏兜底）
						Method = "󰆧", -- 方法（类/对象上的函数）
						Function = "󰆧", -- 普通函数
						Constructor = "", -- 构造函数（如 new / __init__）

						Field = "󰜢", -- 结构体 / 类中的字段
						Variable = "󰀫", -- 变量（局部 / 全局）
						Property = "󰜢", -- 属性（getter/setter，本质类似 Field）

						Class = "󰠱", -- 类
						Interface = "", -- 接口（TypeScript / Java 常见）
						Struct = "󰙅", -- 结构体（C / Rust 常见）

						Module = "", -- 模块 / 包 / namespace
						Unit = "󰑭", -- 单位（极少见，部分语言有）
						Value = "󰎠", -- 值（常见于枚举 / 常量值）

						Enum = "", -- 枚举类型
						EnumMember = "", -- 枚举成员（enum 中的具体值）

						Constant = "󰏿", -- 常量（const / final）

						Keyword = "󰌋", -- 关键字（if / for / return 等）
						Operator = "󰆕", -- 运算符（+ - == 等）

						Snippet = "", -- 代码片段（你现在只来自 LuaSnip）
						Color = "󰏘", -- 颜色值（#ff0000 / rgb() 等）

						File = "󰈙", -- 文件路径
						Folder = "󰉋", -- 文件夹路径
						Reference = "󰈇", -- 引用（跳转相关，较少）

						Event = "", -- 事件（前端 / 框架常见）
						TypeParameter = "", -- 泛型参数（<T>，很少显示）
					}
					vim_item.kind = ((kind_icons[vim_item.kind] or "") .. " " .. vim_item.kind) or ""

					vim_item.abbr = vim_item.abbr or ""

					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[SNIP]",
						buffer = "[BUF]",
						path = "[PATH]",
					})[entry.source.name] or ""

					return vim_item
				end,
			},

			-- 美化窗口
			window = {
				completion = cmp.config.window.bordered({
					max_height = 13, -- 补全菜单最大行数
					max_width = 50, -- 补全菜单最大宽度
				}),
				documentation = cmp.config.window.bordered({
					max_height = 20, -- 文档最大行数
					max_width = 65, -- 文档最大宽度
				}),
			},

			-- 补全顺序
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.exact, -- 完全匹配最优先
					cmp.config.compare.score, -- 匹配程度（核心）
					cmp.config.compare.recently_used, -- 最近用过的靠前（很实用）
					cmp.config.compare.kind, -- Function / Variable
					cmp.config.compare.length, -- 短的优先
					-- cmp.config.compare.locality,  -- 离光标近的优先
					cmp.config.compare.order, -- 最后兜底
				},
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

				-- 手动开启补全菜单
				["<C-r>"] = cmp.mapping.complete(),

				-- 滚动补全文档
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

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
				{ name = "luasnip", keyword_length = 2 }, -- 启用 luasnip
				{ name = "buffer", keyword_length = 3 },
				{ name = "path" },
			}),
		})

		-- cmdline配置
		local cmdline_mapping = {
			["<Tab>"] = {
				c = function()
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						cmp.complete()
					end
				end,
			},
			["<C-n>"] = {
				c = function()
					if cmp.visible() then
						cmp.select_next_item()
					end
				end,
			},
			["<C-p>"] = {
				c = function()
					if cmp.visible() then
						cmp.select_prev_item()
					end
				end,
			},
			["<C-e>"] = {
				c = function()
					if cmp.visible() then
						cmp.abort()
					end
				end,
			},
			["<C-r>"] = {
				c = function()
					cmp.complete()
				end,
			},
			-- ["<CR>"] = {
			-- 	c = cmp.mapping.confirm({ select = true }),
			-- },
		}

		cmp.setup.cmdline({ "/", "?" }, {
			-- mapping = cmp.mapping.preset.cmdline(),
			mapping = cmdline_mapping,
			-- autocomplete = {
			-- 	cmp.TriggerEvent.TextChanged,
			-- },
			sources = {
				{ name = "buffer", keyword_length = 1 },
			},
		})

		cmp.setup.cmdline(":", {
			-- mapping = cmp.mapping.preset.cmdline(),
			mapping = cmdline_mapping,
			-- autocomplete = {
			-- autocomplete = {
			-- 	cmp.TriggerEvent.TextChanged,
			-- },
			sources = cmp.config.sources({
				{ name = "path", keyword_length = 2 }, -- 文件路径补全
			}, {
				{ name = "cmdline", keyword_length = 1 }, -- vim 命令补全
			}),
		})
	end,
}
