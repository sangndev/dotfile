---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

--Settings
do
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.netrw_banner = 0

	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.termguicolors = true
	vim.o.mouse = "a"
	vim.o.showmode = false
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	vim.o.inccommand = "split"
	vim.o.cursorline = true
	vim.o.scrolloff = 10
	vim.o.confirm = true
	vim.o.tabstop = 2
	vim.o.softtabstop = 2
	vim.o.shiftwidth = 2
	vim.o.shiftwidth = 2
	vim.o.colorcolumn = "80"
	vim.o.signcolumn = "yes"
	vim.o.winborder = "rounded"
	vim.o.wrap = false
	vim.o.cmdheight = 0
	vim.o.laststatus = 3

	vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })
	vim.keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "Set no hilighting", silent = true })
	vim.keymap.set("i", "jk", "<esc>", { desc = "Set to normal mode", silent = true })
	vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Moving block to top", silent = true })
	vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Moving block to bottom", silent = true })
	vim.keymap.set("v", "<", "<gv", { desc = "Untab block", silent = true })
	vim.keymap.set("v", ">", ">gv", { desc = "Tab block", silent = true })
	vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up but keep cursor center", silent = true })
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down but keep cursor center", silent = true })
	vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next match but keep cursor center", silent = true })
	vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to prev match but keep cursor center", silent = true })
	vim.keymap.set("n", "ss", "<C-w>s<C-w>p", { desc = "Split window", silent = true })
	vim.keymap.set("n", "sv", "<C-w>v<C-w>p", { desc = "Vertical split window", silent = true })
	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom" })

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

-- Vim Pack
do
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end

	-- This autocommand runs after a plugin is installed or updated and
	--  runs the appropriate build command for that plugin if necessary.
	--
	-- See `:help vim.pack-events`
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end

			if name == "LuaSnip" then
				if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
					run_build(name, { "make", "install_jsregexp" }, ev.data.path)
				end
				return
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
				return
			end
		end,
	})
end

-- Plugins
do
	-- [[ Guess indent ]]
	vim.pack.add({ gh("NMAC427/guess-indent.nvim") })
	require("guess-indent").setup({})

	-- [[ Git signs ]]
	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
	require("gitsigns").setup({
		signs = {
			add = { text = "+" }, ---@diagnostic disable-line: missing-fields
			change = { text = "~" }, ---@diagnostic disable-line: missing-fields
			delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
			topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
			changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
		},
	})

	-- [[ Vim Fugitive ]]
	vim.pack.add({ gh("tpope/vim-fugitive") })

	-- [[ Oil ]]
	vim.pack.add({ gh("stevearc/oil.nvim") })
	require("oil").setup({
		view_options = {
			show_hidden = true,
		},
	})
	vim.keymap.set("n", "<leader>e", function()
		if vim.bo.filetype == "oil" then
			require("oil.actions").close.callback()
		else
			vim.cmd("Oil")
		end
	end, { desc = "Explorer", silent = true })

	-- [[ Autopairs ]]
	vim.pack.add({ gh("windwp/nvim-autopairs") })
	require("nvim-autopairs").setup({})

	-- [[ UI2 ]]
	require("vim._core.ui2").enable({
		enable = true,
		msg = {
			targets = {
				[""] = "msg",
				empty = "cmd",
				bufwrite = "msg",
				confirm = "cmd",
				emsg = "pager",
				echo = "msg",
				echomsg = "msg",
				echoerr = "pager",
				completion = "cmd",
				list_cmd = "pager",
				lua_error = "pager",
				lua_print = "msg",
				progress = "pager",
				rpc_error = "pager",
				quickfix = "msg",
				search_cmd = "cmd",
				search_count = "cmd",
				shell_cmd = "pager",
				shell_err = "pager",
				shell_out = "pager",
				shell_ret = "msg",
				undo = "msg",
				verbose = "pager",
				wildlist = "cmd",
				wmsg = "msg",
				typed_cmd = "cmd",
			},
			cmd = {
				height = 0.5,
			},
			dialog = {
				height = 0.5,
			},
			msg = {
				height = 0.3,
				timeout = 5000,
			},
			pager = {
				height = 0.5,
			},
		},
	})

	-- [[ Tiny cmdline ]]
	vim.pack.add({ gh("rachartier/tiny-cmdline.nvim") })
	require("tiny-cmdline").setup({
		native_types = {},
	})

	-- [[ Comment ]]
	vim.pack.add({ gh("numToStr/Comment.nvim"), gh("JoosepAlviste/nvim-ts-context-commentstring") })
	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})

	-- [[ Git conflict ]]
	vim.pack.add({ gh("akinsho/git-conflict.nvim") })
	require("git-conflict").setup({
		default_mapping = {
			next = "]x",
			prev = "[x",
		},
	})
end

-- Colorscheme
do
	vim.pack.add({
		gh("rmehri01/onenord.nvim"),
	})

	local colors = require("onenord.colors").load()
	require("onenord").setup({
		theme = "light",
		disable = {
			background = true,
			float_background = true,
		},
		custom_highlights = {
			Visual = { bg = colors.cyan, fg = colors.bg },
			StatusLine = { bg = "NONE" },
		},
	})

	vim.cmd("colorscheme onenord")
end

-- Treesitter
do
	-- [[ Configure Treesitter ]]
	vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

	-- Ensure basic parsers are installed
	local parsers =
		{ "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
	require("nvim-treesitter").install(parsers)

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		-- Check if a parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- Enable syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- Enable treesitter based folds
		-- For more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		-- Check if treesitter indentation is available for this language, and if so enable it
		-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		-- Enable treesitter based indentation
		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")

			if vim.tbl_contains(installed_parsers, language) then
				-- Enable the parser if it is already installed
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
				require("nvim-treesitter").install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

-- Fuzzy finder
do
	---@type (string|vim.pack.Spec)[]
	local telescope_plugins = {
		gh("nvim-lua/plenary.nvim"),
		gh("nvim-telescope/telescope.nvim"),
		gh("nvim-telescope/telescope-ui-select.nvim"),
	}
	if vim.fn.executable("make") == 1 then
		table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
	end
	vim.pack.add(telescope_plugins)
	local actions = require("telescope.actions")
	require("telescope").setup({
		defaults = {
			path_display = { "smart" },
			initial_mode = "normal",
			mappings = {
				i = {
					["<Down>"] = actions.cycle_history_next,
					["<Up>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
				},
				n = {
					["q"] = actions.close,
				},
			},
		},
		pickers = {
			-- Default configuration for builtin pickers goes here:
			find_files = {
				theme = "ivy",
				layout_config = { height = 100 },
			},
			buffers = {
				theme = "ivy",
				layout_config = { height = 100 },
			},
			-- Now the picker_config_key will be applied every time you call this
			-- builtin picker
		},
		extensions = {
			["ui-select"] = { require("telescope.themes").get_dropdown() },
		},
	})

	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	local themes = require("telescope.themes")
	local function ivy_opts(opts)
		return themes.get_ivy(vim.tbl_deep_extend("force", {
			layout_config = {
				height = 100,
			},
		}, opts or {}))
	end

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Global find file" })
	vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Opened buffer" })
	vim.keymap.set("n", "<leader>ps", function()
		builtin.grep_string(ivy_opts({
			search = vim.fn.input("Grep > "),
		}))
	end, { desc = "Grep search" })
end

-- LSP
do
	-- Packages
	vim.pack.add({ gh("j-hui/fidget.nvim") })
	require("fidget").setup({
		notification = {
			override_vim_notify = false,
			window = {
				winblend = 0, -- Background color opacity in the notification window
				border = "rounded", -- Border around the notification window
				x_padding = 0, -- Padding from right edge of window boundary
				y_padding = 0, -- Padding from bottom edge of window boundary
			},
		},
	})

	-- [[ Settings ]]
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },

		-- Can switch between these as you prefer
		virtual_text = true, -- Text shows up at the end of the line
		virtual_lines = false, -- Text shows up underneath the line, with virtual lines

		-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})

	-- [[ LSP augroup ]]
	vim.api.nvim_create_user_command("LspReset", function(opts)
		local target = opts.args

		local function restart(server)
			local clients = vim.lsp.get_clients({ name = server })
			if #clients == 0 then
				print("No active LSP server named: " .. server)
			end

			for _, client in ipairs(clients) do
				if client.server_capabilities and next(client.server_capabilities) ~= nil then
					print("client to restart: " .. client.name)
					vim.lsp.enable(client.name, false)
					vim.lsp.enable(client.name, true)
				end
			end
		end

		if target ~= "" then
			restart(target)
		else
			local clients = vim.lsp.get_clients()
			if #clients == 0 then
				print("No active LSP servers to restart")
				return
			end
			for _, client in ipairs(clients) do
				restart(client.name)
			end
		end
	end, {
		nargs = "?",
		complete = function()
			return vim.tbl_map(function(c)
				return c.name
			end, vim.lsp.get_clients())
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end
			map("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
			map("<leader>q", vim.diagnostic.setloclist, "[L]ist [D]iagnostics")
			map("]d", vim.diagnostic.goto_next, "Goto next [D]iagnostics")
			map("[d", vim.diagnostic.goto_prev, "Goto prev [D]iagnostics")
			map("<leader>d", vim.diagnostic.open_float, "Open diagnostic in float window")
		end,
	})

	---@type table<string, vim.lsp.Config>
	local servers = {
		-- clangd = {},
		-- gopls = {},
		-- pyright = {},
		-- rust_analyzer = {},
		--
		-- Some languages (like typescript) have entire language plugins that can be useful:
		--    https://github.com/pmizio/typescript-tools.nvim
		--
		-- But for many setups, the LSP (`ts_ls`) will work just fine
		ts_ls = {},
		eslint = {},
		tailwindcss = {},

		stylua = {}, -- Used to format Lua code

		-- Special Lua Config, as recommended by neovim help docs
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = { "lua/?.lua", "lua/?/init.lua" },
					},
					workspace = {
						checkThirdParty = false,
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
	}

	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	})

	require("mason").setup({})

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		-- You can add other tools here that you want Mason to install
	})

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		vim.lsp.enable(name)
	end
end

-- Formatting
do
	vim.pack.add({ gh("stevearc/conform.nvim") })
	require("conform").setup({
		notify_on_error = false,
		default_format_opts = {
			lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
		},
		-- You can also specify external formatters in here.
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier", "prettierd", stop_after_first = true },
			typescript = { "prettier", "prettierd", stop_after_first = true },
			javascriptreact = { "prettier", "prettierd", stop_after_first = true },
			typescriptreact = { "prettier", "prettierd", stop_after_first = true },
			json = { "prettier", "prettierd", stop_after_first = true },
			css = { "prettier", "prettierd", stop_after_first = true },
			svelte = { "prettier", "prettierd", stop_after_first = true },
			html = { "prettier", "prettierd", stop_after_first = true },
			markdown = { "prettier", "prettierd", stop_after_first = true },
			yaml = { "prettier", "prettierd", stop_after_first = true },
			go = { "gofumpt" },
		},
	})

	vim.keymap.set({ "n", "v" }, "<leader>f", function()
		require("conform").format({ async = true })
	end, { desc = "[F]ormat buffer" })
end

-- Autocompletion & Snippets
do
	vim.pack.add({ { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") } })
	require("luasnip").setup({})
	vim.pack.add({ gh("rafamadriz/friendly-snippets") })
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/" })

	vim.pack.add({ { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") } })
	require("blink.cmp").setup({
		keymap = {
			preset = "none",
			["<C-o>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },

			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },

			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },

			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},
		snippets = { preset = "luasnip" },
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			accept = { auto_brackets = { enabled = false } },
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = { auto_show = true, auto_show_delay_ms = 250, window = { border = "rounded" } },
		},
		fuzzy = { implementation = "lua" },
		signature = { enabled = true, window = { border = "rounded", show_documentation = false } },
	})
end

-- Status line

do
	function _G.short_filepath()
		local path = vim.fn.expand("%:~:.")
		local parts = vim.split(path, "/")
		if #parts <= 3 then
			return path
		end

		local last_parts = { unpack(parts, #parts - 2, #parts) }
		return "~../" .. table.concat(last_parts, "/")
	end

	function _G.mode()
		local mode_map = {
			n = "NORMAL ",
			i = "INSERT ",
			v = "VISUAL ",
			V = "V-LINE ",
			[""] = "V-BLOCK ",
			c = "COMMAND ",
			s = "SELECT ",
			S = "S-LINE ",
			[""] = "S-BLOCK ",
			R = "REPLACE ",
			t = "TERMINAL ",
		}
		local mode = vim.fn.mode()
		return mode_map[mode] or mode
	end

	function _G.get_lsp_diagnostics()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			return ""
		end

		local diagnostics = vim.diagnostic.get(0)
		local errors = 0
		local warnings = 0

		for _, diagnostic in ipairs(diagnostics) do
			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				errors = errors + 1
			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				warnings = warnings + 1
			end
		end

		if errors == 0 and warnings == 0 then
			return ""
		end

		local parts = {}
		if errors > 0 then
			table.insert(parts, string.format("%%#DiagnosticError#E:%d%%#StatusLine#", errors))
		end
		if warnings > 0 then
			if errors > 0 then
				table.insert(parts, " ")
			end
			table.insert(parts, string.format("%%#DiagnosticWarn#W:%d%%#StatusLine#", warnings))
		end

		return table.concat(parts)
	end

	function _G.recording_status()
		local reg = vim.fn.reg_recording()
		if reg == "" then
			return ""
		else
			return "[Recording @" .. reg .. "]"
		end
	end

	vim.o.statusline = table.concat({
		"%#PmenuSel#",
		" ",
		"%{%v:lua.mode()%}",
		"%#StatusLine#",
		"%{%v:lua.recording_status()%}",
		" ",
		"%{%v:lua.short_filepath()%}",
		"%m",
		" ",
		"%=",
		"%{%v:lua.get_lsp_diagnostics()%}",
		" ",
		"%{&filetype}",
		" ",
		"[%p%%]",
		" ",
	})
end
