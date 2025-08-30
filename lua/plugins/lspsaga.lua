return {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    opts = {
        finder = {
            key = {
                toggle_or_open = "<CR>"
            }
        }
    },
    keys = {
        { "<leader>lr", ":Lspsaga rename<CR>" },  -- 重命名
        { "<leader>lc", ":Lspsaga code_action<CR>" },  
        { "<leader>ld", ":Lspsaga goto_definition<CR>" },  -- 跳转至定义
        { "<leader>lh", ":Lspsaga hover_doc<CR>" },  -- 展开注释
        { "<leader>lR", ":Lspsaga finder<CR>" },  -- 查找器
        { "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>"},  -- 跳转到下一个诊断
        { "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>"},  -- 跳转到下一个诊断
    }
}
