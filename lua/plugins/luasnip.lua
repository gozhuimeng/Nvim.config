return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",

	config = function()
		local ls = require("luasnip")

		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			-- enable_autosnippets = false,
			enable_autosnippets = true,
		})

		local ls_from_lua = require("luasnip.loaders.from_lua")
		ls_from_lua.lazy_load()

		-- keymap config
		local function expand_or_jump_to_next()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end

		local function jump_to_previous()
			if ls.jump(-1) then
				ls.jump(-1)
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

		ls_from_lua.lazy_load({
			paths = { vim.fn.stdpath("config") .. "/lua/snippets/lua" },
		})

		-- disenable
		-- local ls_from_vscode = require("luasnip.loaders.from_vscode")
	end,
}
