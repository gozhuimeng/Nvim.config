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
