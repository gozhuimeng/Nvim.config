return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		-- "rafamadriz/friendly-snippets",
	},
	enabled = false,
	event = "VeryLazy",
	opts = {
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		keymap = {
			preset = "super-tab",

			-- preset = "none",
			-- -- 补全
			-- ["<Tab>"] = {
			-- 	function(cmp)
			-- 		if cmp.snippet_active({ direction = 1 }) then
			-- 			return cmp.snippet_forward()
			-- 		end
			-- 	end,
			-- 	function(cmp)
			-- 		if cmp.is_visible() then
			-- 			return cmp.accept()
			-- 		end
			-- 	end,
			-- 	"fallback",
			-- },
			--
			-- ["<A-Tab"] = {
			-- 	function(cmp)
			-- 		if cmp.snippet_active({ direction = -1 }) then
			-- 			return cmp.snippet_backward()
			-- 		end
			-- 	end,
			-- 	"fallback",
			-- },
			--
			-- -- 显示补全菜单
			-- ["<S-space>"] = {
			-- 	"show",
			-- 	"fallback",
			-- },
			--
			-- -- 使用回车确认补全
			-- -- ["<CR>"] = {
			-- -- 	function(cmp)
			-- -- 		if cmp.is_visible() then
			-- -- 			return cmp.accept()
			-- -- 		end
			-- -- 	end,
			-- -- 	"fallback",
			-- -- },
			--
			-- -- 选择补全项
			-- ["<C-n>"] = { "select_next", "fallback_to_mappings" },
			-- ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			--
			-- ["<Up>"] = { "select_next", "fallback" },
			-- ["<Down>"] = { "select_prev", "fallback" },
			--
			-- -- 显示隐藏函数签名
			-- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			--
			-- -- 滚动文档
			-- ["<C-J>"] = { "scroll_documentation_up", "fallback" },
			-- ["<C-j>"] = { "scroll_documentation_down", "fallback" },
			--
			-- -- 关闭补全
			-- ["<C-e>"] = { "hide", "fallback" },
		},
		sources = {
			default = { "path", "snippets", "buffer", "lsp" },
		},
		snippets = {
			preset = "luasnip",
		},
		cmdline = {
			sources = function()
				local cmd_type = vim.fn.getcmdtype()
				if cmd_type == "/" then
					return { "buffer" }
				end
				if cmd_type == ":" then
					return { "cmdline" }
				end
				return {}
			end,
			keymap = {
				preset = "super-tab",
			},
			completion = {
                -- list = { selection = {auto_insert = true}},
				menu = {
					auto_show = true,
				},
			},
		},
	},
}
