## 个人Nvim配置

### 备注

#### nvim-treesitter

- 需要额外安装`tree-sitter-cli`
- 添加parser后首次启动需要等待小段时间，并且重新启动才能成功加载Treesitter

#### tv.nvim(television.nvim)

- 需要额外安装`television`或是参考文档拉取二进制文件

#### spell

- 每次进入Nvim都将会自动编译缺失`.spl`二进制文件
- 二进制`.spl`如果和`.add`文件版本不一致或功能异常，请使用`:RecompileAllSpell`重新编译所有文件或者通过`:mkspell! <filepath>`编译指定的spell

#### mason

- jdtls
    - 需要拥有java 21或以上的jdk，如果存在多个jdk(例如使用sdkman)，可以在mason.nvim中通过cmd指定jdk

#### opencode.nvim

- 依赖系统命令`lsof`，用于自动检测 opencode 进程
    - Arch: `sudo pacman -S lsof`
    - Debian/Ubuntu: `sudo apt install lsof`
    - macOS: 已有
- 通过 lazy.nvim 加载，使用前请确保 opencode CLI 已安装
- 首次启动需要等待一小段时间初始化

#### molten-nvim

- Neovim 远程插件 Python 环境路径（配置在 `lua/core/basic.lua`）：
    ```lua
    vim.g.python3_host_prog = "/home/meng/.local/bin/pynvim-python"
    ```
- 全局 Python 工具安装（使用 `uv tool install`）：
    - `pynvim`：molten-nvim 远程插件 API
    - `jupyter-core`：提供 `jupyter` 命令（查看内核列表等）
- 项目 Jupyter 内核注册方式：
    ```bash
    cd /path/to/project
    uv add --dev ipykernel
    uv venv
    uv sync
    uv run ipython kernel install --user --env VIRTUAL_ENV $(pwd)/.venv --name=<内核名>
    ```
- 键位映射：以 `<leader>m` 为前缀（如 `<leader>mi` 初始化内核）
- 图像渲染依赖 `image.nvim`，需要支持图形协议的终端（如 Kitty）

