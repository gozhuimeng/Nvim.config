return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    main = "nvim-treesitter.configs",
    opts = {
        highlight = { enable = true }
    },
    branch = "main",
    config = function()
        local nvim_treesitter = require "nvim-treesitter"
        nvim_treesitter.setup()

        local ensure_installed = { "lua" }
        local pattern = {}
        for _,parser in ipairs(ensure_installed) do
            local has_parser, _ = pcall(vim.treesitter.language.inspect, parser)

            if not has_parser then
                nvim_treesitter.install(parser)
            else
                pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
            end
        end
        vim.api.nvim_create_autocmd("FileType", {
            pattern = pattern,
            callback = function()
                vim.treesitter.start()
            end,
        })
        vim.api.nvim_exec_autocmds("FileType", {})
    end,
}
