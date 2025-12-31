return {
    "akinsho/toggleterm.nvim",
    version = "*",

    config = function()
        require("toggleterm").setup({
            size = 30,
            open_mapping = [[<C-/>]],  -- 启动快捷键
            hide_number=true,  -- 不显示行号
            shade_filetypes = {},  -- 不显示阴影的filtype
            shade_fctor = 2,  -- 阴影深度
            start_in_insert = true,  -- 进入终端自动进入插入模式
            insert_mapping = true,  -- insert模式下支持快捷键映射
            terminal_mapping = true,  -- 终端下支持toggleterm自带的快捷键
            persist_size = true,  -- 再次打开保持上次窗口大小
            direction = "float",  -- 浮动显示窗口
            close_on_exit = true,  -- 命令执行完成之后自动关闭终端
            shell = "zsh"
        })
    end,
}
