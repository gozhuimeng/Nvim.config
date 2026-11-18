return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	dependencies = {
		-- {
		-- 	"gozhuimeng/free-snippets",
		-- 	branch = "dev",
		-- },
		{
			dir = "/home/meng/Project/free-snippets",
			branch = "dev",
		},
	},
	config = function()
		local ls = require("luasnip")
		local ls_types = require("luasnip.util.types")

		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			region_check_events = "CursorMoved,CursorMovedI,InsertEnter",
			delete_check_events = "TextChanged,InsertLeave",
			enable_autosnippets = true,
			-- ext_opts 只负责“当前节点”的可视提示。
			-- 下一个节点提示在下面通过 jump_destination + extmark 动态计算。
			ext_opts = {
				[ls_types.insertNode] = {
					active = {
						virt_text = { { " ● CUR", "Comment" } },
					},
				},
				[ls_types.choiceNode] = {
					active = {
						virt_text = { { " ◇ CHOICE", "Comment" } },
					},
				},
			},
		})

		local ls_from_lua = require("luasnip.loaders.from_lua")
		ls_from_lua.lazy_load()

		-- 单独 namespace：专门画“下一个跳转点”提示，便于刷新/清除。
		local next_jump_ns = vim.api.nvim_create_namespace("luasnip_next_jump")

		local function clear_next_jump_marker(bufnr)
			vim.api.nvim_buf_clear_namespace(bufnr or vim.api.nvim_get_current_buf(), next_jump_ns, 0, -1)
		end

		local function update_jump_markers()
			local bufnr = vim.api.nvim_get_current_buf()
			clear_next_jump_marker(bufnr)

			-- 不在 snippet 中时，不显示提示。
			if not ls.in_snippet() then
				return
			end

			local current_node = ls.session.current_nodes[bufnr]
			if not current_node or not current_node.parent or not current_node.parent.snippet then
				return
			end

			local function node_start(node)
				local ok_pos, from_pos = pcall(node.get_buf_position, node, { raw = false })
				if ok_pos and from_pos then
					return from_pos
				end
				return nil
			end

			local snippet = current_node.parent.snippet

			local function collect_forward_jump_nodes()
				if not ls.jumpable(1) then
					return {}
				end

				local ok_node, first = pcall(ls.jump_destination, 1)
				if not ok_node or not first then
					return {}
				end

				local forward_nodes = {}
				local seen = {}
				local node = first

				while node and not seen[node] do
					seen[node] = true
					if node == snippet or node == snippet.insert_nodes[0] then
						break
					end
					if node.parent and node.parent.snippet == snippet and type(node.pos) == "number" and node.pos > 0 then
						table.insert(forward_nodes, node)
					end
					node = node.next
				end

				return forward_nodes
			end

			local forward_nodes = collect_forward_jump_nodes()
			for i, node in ipairs(forward_nodes) do
				local pos = node_start(node)
				if pos then
					local label = i == 1 and " ← NEXT" or " · JUMP"
					local hl = i == 1 and "DiagnosticHint" or "NonText"
					vim.api.nvim_buf_set_extmark(bufnr, next_jump_ns, pos[1], pos[2], {
						virt_text = { { label, hl } },
						virt_text_pos = "eol",
					})
				end
			end
		end

		-- 插入/普通模式都实时更新；仅切换 buffer 时清空，避免残留。
		local marker_group = vim.api.nvim_create_augroup("LuaSnipNextJumpMarker", { clear = true })
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "InsertEnter", "InsertLeave", "BufEnter" }, {
			group = marker_group,
			callback = function()
				update_jump_markers()
			end,
			desc = "更新LuaSnip下一个跳转点提示",
		})

		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			group = marker_group,
			callback = function(args)
				clear_next_jump_marker(args.buf)
			end,
			desc = "清理LuaSnip跳转点提示",
		})

		-- keymap config
		local function expand_or_jump_to_next()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
				vim.schedule(update_jump_markers)
			end
		end

		local function jump_to_previous()
			if ls.jumpable(-1) then
				ls.jump(-1)
				vim.schedule(update_jump_markers)
			end
		end

		local function choice_next()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end

		local function choice_previous()
			if ls.choice_active() then
				ls.change_choice(-1)
			end
		end

		local function unlink_current_snippet()
			if ls.in_snippet() then
				-- 主动退出当前 snippet 会话，避免后续误跳回旧占位。
				ls.unlink_current()
				clear_next_jump_marker()
			end
		end

		vim.keymap.set({ "i", "s" }, "<C-j>", expand_or_jump_to_next, {
			silent = true,
			desc = "跳转到下一处输入",
		})

		vim.keymap.set({ "i", "s" }, "<C-k>", jump_to_previous, {
			silent = true,
			desc = "跳转到上一处输入",
		})

		vim.keymap.set({ "i", "s" }, "<C-n>", choice_next, {
			silent = true,
			desc = "跳转到下一个选择",
		})

		vim.keymap.set({ "i", "s" }, "<C-p>", choice_previous, {
			silent = true,
			desc = "跳转到上一处选择",
		})

		vim.keymap.set({ "i", "s" }, "<C-g>", unlink_current_snippet, {
			silent = true,
			desc = "取消当前snippet跳转点",
		})

		-- ls_from_lua.lazy_load({
		-- 	paths = { vim.fn.stdpath("config") .. "/lua/snippets/lua" },
		-- })

		-- disenable
		-- local ls_from_vscode = require("luasnip.loaders.from_vscode")
	end,
}
