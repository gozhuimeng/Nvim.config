## 个人Nvim配置

### 外部依赖

仓库只包含配置和脚本，以下命令需要自行安装（其余 LSP / 格式化工具由 Mason 管理）：

| 命令 | 用途 | 安装方式 |
|---|---|---|
| `nvim` >= 0.10 | 需要 `vim.system` / `vim.fs`（rust-qmd-check） | 包管理器 |
| `git` | lazy.nvim 拉取插件 | 包管理器 |
| `tree-sitter` | nvim-treesitter 编译 parser | `cargo install tree-sitter-cli` |
| `tv` | television.nvim | 见下文 |
| `lsof` | opencode.nvim 检测进程 | 见下文 |
| `rustc` / `cargo` | qmd 中 Rust 代码的静态检查 | `rustup` |
| `rustfmt` | 格式化 qmd 中的 Rust 代码块 | `rustup component add rustfmt` |
| `panache` | 格式化 Quarto / Markdown（含代码块） | `:MasonInstall panache` |
| `black` | 格式化 qmd 中的 Python 代码块 | `:MasonInstall black` |
| `python3` + `pynvim` / `jupyter-core` | molten-nvim | 见 molten-nvim 一节 |

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
    vim.g.python3_host_prog = "/home/zephyr/.local/bin/pynvim-python"
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
- 键位映射：以 `<leader>j` 为前缀（如 `<leader>ji` 初始化内核）
- 图像渲染依赖 `image.nvim`，需要支持图形协议的终端（如 Kitty）

#### qmd 代码块格式化（panache）

- 仓库内相关文件：
    - `panache/config.toml`：panache 用户级配置，声明代码块的格式化器
        - Rust → `rustfmt-evcxr`
        - Python → `black`
    - `bin/rustfmt-evcxr`：rustfmt 包装器。学习笔记常写 evcxr 风格的顶层语句
      （`let x = 1;`），rustfmt 无法直接解析，所以先包进 `fn main` 再拆掉，
      同时保留 chunk 顶部的 `:dep` 行。
- `lua/core/basic.lua` 做了两件事：
    - 把仓库的 `bin/` 加入 `PATH`
    - 设置 `PANACHE_CONFIG` 指向 `panache/config.toml`
- 因此不再需要维护 `~/.config/panache/config.toml`。
- 保存 qmd 时由 conform 调用 `panache` 完成格式化；手动格式化用 `<leader>lf`。
- 项目根目录若有自己的 `panache.toml`，会**覆盖**用户级配置；需要继承时写：
    ```toml
    extend = "~/.config/nvim/panache/config.toml"
    ```
- 可选：想把 Python 代码块从 `black` 换成 `ruff format`，修改
  `panache/config.toml` 里的 `python = "ruff"`，并安装 ruff：
    ```bash
    uv tool install ruff
    ```
- 在 nvim 之外单独使用 panache 时，需要自己设置环境：
    ```bash
    export PATH="$HOME/.config/nvim/bin:$PATH"
    export PANACHE_CONFIG="$HOME/.config/nvim/panache/config.toml"
    ```

