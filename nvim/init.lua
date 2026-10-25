vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.regexpengine = 0
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamed"
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.cursorline = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cmdheight = 1
vim.o.ttyfast = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.encoding = "utf8"
vim.o.shiftround = true
vim.o.pumheight = 10
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "80"
vim.o.winborder = "rounded"
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.wrap = false
vim.o.laststatus = 3
vim.o.pumborder = "rounded"

-- ------------------------------------------------------------
-- Basic mappings
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- Autocmd
-- ------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ------------------------------------------------------------
-- Packages installation
-- ------------------------------------------------------------
-- Git
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
vim.pack.add({ "https://github.com/akinsho/git-conflict.nvim" })
-- Explorer
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
-- Colorscheme
vim.pack.add({ "https://github.com/rmehri01/onenord.nvim" })
-- Lsp
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})
-- Lsp process
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
-- Formating
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
-- Search & Grep
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim"
})
if vim.fn.executable("make") == 1 then
  vim.pack.add({ "https://github.com/nvim-telescope/telescope-fzf-native.nvim" })
end
-- Syntax highlighting
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

-- ------------------------------------------------------------
-- Colorscheme
-- ------------------------------------------------------------
local colors = require("onenord.colors").load()
require("onenord").setup({
  theme = "light",
  disable = {
    background = true,
    float_background = true,
  },
  custom_highlights = {
    Visual = { bg = colors.cyan, fg = colors.bg },
    -- StatusLine = { bg = "NONE" },
  },
})

vim.cmd("colorscheme onenord")

-- ------------------------------------------------------------
-- Explorer
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- Git
-- ------------------------------------------------------------
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

require("git-conflict").setup({
  default_mapping = {
    next = "]x",
    prev = "[x",
  },
})

-- ------------------------------------------------------------
-- Lsp & Autocompletion
-- ------------------------------------------------------------
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
    -- Trigger completion
    map("<C-o>", "<C-x><C-o>", "Open omnifunc completion", "i")
    vim.keymap.set("i", "<CR>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-y>"
      end
      return "<CR>"
    end, { expr = true })

    map("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
    map("<leader>q", vim.diagnostic.setloclist, "[L]ist [D]iagnostics")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Goto next [D]iagnostics")
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Goto prev [D]iagnostics")
    map("<leader>d", vim.diagnostic.open_float, "Open diagnostic in float window")
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  ts_ls = {},
  eslint = {},
  tailwindcss = {},
  svelte = {}
}

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

-- ------------------------------------------------------------
-- Lsp process
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- Formatting
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- Search & Grep
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- Status line
-- ------------------------------------------------------------
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
    n = "%#NormalMode# N ",
    i = "%#InsertMode# I ",
    v = "%#VisualMode# V ",
    V = "%#VisualMode# VL ",
    [""] = "%#VisualMode# VB ",
    c = "%#CommandMode# C ",
    s = "%#PmenuSel# S ",
    S = "%#PmenuSel# SL ",
    [""] = "%#PmenuSel# SB ",
    R = "%#PmenuSel# R ",
    t = "%#PmenuSel# T ",
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

-- ------------------------------------------------------------
-- Syntax highlighting
-- ------------------------------------------------------------
-- Ensure basic parsers are installed
local parsers =
{ "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
require("nvim-treesitter").install(parsers)

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
