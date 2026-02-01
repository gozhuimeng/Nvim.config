return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		extensions = { "nvim-tree" },
		sections = {
			-- lualine_b = { "branch", "diff" },
			lualine_x = {
				function()
					-- Always show a stable Copilot indicator in the statusline.
					if vim.fn.exists(":Copilot") == 0 then
						return ""
					end
					local ok, enabled = pcall(vim.fn["copilot#Enabled"])
					if ok and enabled == 1 then
						return "Copilot"
					end
					return "Copilot(off)"
				end,
				"filesize",
				"encoding",
				"filetype",
			},
		},
	},
}
