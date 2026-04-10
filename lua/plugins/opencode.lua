return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	dependencies = {
		{
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {
					enabled = true,
				},
				picker = {
					enabled = true,
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		-- 必须开启！用于监听文件变化并自动重载缓冲区
		vim.o.autoread = true

		-- ========== 插件配置 ==========
		-- 注意：必须在首次 require("opencode") 前设置
		vim.g.opencode_opts = {
			server = {
				port = nil,
				start = function()
					require("opencode.terminal").open("opencode --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
				stop = function()
					require("opencode.terminal").close()
				end,
				toggle = function()
					require("opencode.terminal").toggle("opencode --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
			},

			contexts = {
				["@this"] = function(context)
					return context:this()
				end,
				["@buffer"] = function(context)
					return context:buffer()
				end,
				["@buffers"] = function(context)
					return context:buffers()
				end,
				["@visible"] = function(context)
					return context:visible_text()
				end,
				["@diagnostics"] = function(context)
					return context:diagnostics()
				end,
				["@quickfix"] = function(context)
					return context:quickfix()
				end,
				["@diff"] = function(context)
					return context:git_diff()
				end,
				["@marks"] = function(context)
					return context:marks()
				end,
				["@grapple"] = function(context)
					return context:grapple_tags()
				end,
			},

			-- 内置 Prompt 模板 (中文)
			prompts = {
				ask = { prompt = "", ask = true, submit = true },
				diagnostics = { prompt = "解释以下诊断信息：@diagnostics", submit = true },
				diff = { prompt = "审查以下 git diff 的正确性和可读性：@diff", submit = true },
				document = { prompt = "为以下代码添加文档注释：@this", submit = true },
				explain = { prompt = "解释以下代码及其上下文：@this", submit = true },
				fix = { prompt = "修复以下诊断问题：@diagnostics", submit = true },
				implement = { prompt = "实现以下功能：@this", submit = true },
				optimize = { prompt = "优化以下代码的性能和可读性：@this", submit = true },
				review = { prompt = "审查以下代码的正确性和可读性：@this", submit = true },
				test = { prompt = "为以下代码编写测试用例：@this", submit = true },
			},

			-- ask 输入框
			ask = {
				prompt = "询问 opencode：",
				completion = "customlist,v:lua.opencode_completion",
			},

			-- select 选择器
			select = {
				prompt = "opencode：",
				sections = {
					prompts = true,
					commands = {
						["session.new"] = "开始新会话",
						["session.select"] = "选择会话",
						["session.share"] = "分享当前会话",
						["session.interrupt"] = "中断当前操作",
						["session.compact"] = "压缩会话上下文",
						["session.undo"] = "撤销上一步",
						["session.redo"] = "重做上一步",
						["agent.cycle"] = "切换 AI 模型",
						["prompt.submit"] = "提交当前输入",
						["prompt.clear"] = "清空当前输入",
					},
					server = true,
				},
			},

			-- LSP 集成 (实验性，默认关闭)
			lsp = {
				enabled = false,
				filetypes = nil,
				handlers = {
					hover = { enabled = true, model = nil },
					code_action = { enabled = true },
				},
			},

			-- 事件处理
			events = {
				enabled = true,
				reload = true,
				permissions = {
					enabled = true,
					idle_delay_ms = 1000,
					edits = { enabled = true },
				},
			},
		}

		-- ========== 快捷键配置 ==========
		local function opencode_safe(fn)
			local ok, err = pcall(fn)
			if not ok then
				vim.notify(
					"opencode 键位执行失败: " .. tostring(err),
					vim.log.levels.ERROR,
					{ title = "opencode" }
				)
			end
		end

		-- Leader 方案（更稳定，避免 <C-a>/<C-x> 被终端或其他插件吞键）
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			opencode_safe(function()
				require("opencode").ask("@this: ", { submit = true })
			end)
		end, { desc = "询问 opencode 关于选择内容" })

		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			opencode_safe(function()
				require("opencode").select()
			end)
		end, { desc = "打开 opencode 选择器" })

		vim.keymap.set("t", "<leader>oa", function()
			opencode_safe(function()
				require("opencode").ask("@this: ", { submit = true })
			end)
		end, { desc = "终端中询问 opencode" })

		vim.keymap.set("t", "<leader>ox", function()
			opencode_safe(function()
				require("opencode").select()
			end)
		end, { desc = "终端中打开 opencode 选择器" })

		vim.keymap.set({ "n", "t" }, "<leader>ot", function()
			require("opencode").toggle()
		end, { desc = "切换 opencode 面板" })

		-- 向 opencode 询问当前选择/光标位置
		vim.keymap.set({ "n", "x" }, "<C-a>", function()
			opencode_safe(function()
				require("opencode").ask("@this: ", { submit = true })
			end)
		end, { desc = "询问 opencode 关于选择内容" })

		-- 打开选择器，选择 prompt 或命令
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			opencode_safe(function()
				require("opencode").select()
			end)
		end, { desc = "打开 opencode 选择器" })

		-- 切换 opencode 面板显示
		vim.keymap.set({ "n", "t" }, "<C-,>", function()
			require("opencode").toggle()
		end, { desc = "切换 opencode 面板" })

		-- 配合 motion 使用，将选中区域发送给 opencode
		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "添加范围到 opencode", expr = true })

		-- 发送整行
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "发送整行到 opencode", expr = true })

		-- 滚动 opencode 面板
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "向上滚动 opencode" })

		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "向下滚动 opencode" })

		-- 恢复数字增减功能
		vim.keymap.set("n", "+", "<C-a>", { desc = "增加光标下的数字", noremap = true })
		vim.keymap.set("n", "-", "<C-x>", { desc = "减少光标下的数字", noremap = true })

		-- ========== 事件监听 ==========
		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:*",
			callback = function(args)
				local event = args.data and args.data.event
				if event and event.type == "session.idle" then
					vim.notify("opencode 响应完成", vim.log.levels.INFO, { title = "opencode" })
				end
			end,
		})

		-- ========== 检查配置是否正确 ==========
		-- 运行 :checkhealth opencode 检查
	end,
}
