return {  -- 快速跳转
    "smoka7/hop.nvim",
    opts = {
        hint_position = 3,  -- 高亮显示在词尾
    },
    keys = {
        { "<leader>hp", "<Cmd>HopWord<CR>", desc = "hop跳转", silent = true }
    }
}
