return {
	-- quarto-nvim: Quarto 文档支持（.qmd 文件）
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim", -- 代码块 LSP 支持
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "quarto", "markdown" },
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					languages = { "python" },
					chunks = "all",
				},
				codeRunner = {
					enabled = true,
					default_method = "molten", -- 使用 molten-nvim 作为运行器
				},
			})

			-- 代码运行按键映射（运行后进入 i 模式）
			local runner = require("quarto.runner")
			local function run_and_insert(fn)
				return function()
					pcall(fn)
					vim.cmd("startinsert")
				end
			end
			vim.keymap.set(
				"n",
				"<leader>rc",
				run_and_insert(runner.run_cell),
				{ desc = "运行当前 cell", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>ra",
				run_and_insert(runner.run_above),
				{ desc = "运行当前及上方 cell", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>rA",
				run_and_insert(runner.run_all),
				{ desc = "运行所有 cell", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>rl",
				run_and_insert(runner.run_line),
				{ desc = "运行当前行", silent = true }
			)
			vim.keymap.set(
				"v",
				"<leader>rv",
				run_and_insert(runner.run_range),
				{ desc = "运行选区代码", silent = true }
			)
		end,
	},
}
