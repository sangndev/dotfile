---@type vim.lsp.Config
return {
  name = "vtsls",
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vtsls", "--stdio" },
  init_options = {
    hostInfo = "neovim",
  },

  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },

  ---@param bufnr integer
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Detect nearest project root
    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      "package-lock.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      "bun.lockb",
      "bun.lock",
      "deno.lock",
    })

    -- Fallback: file's directory
    if not root or root == "" then
      root = vim.fs.dirname(fname)
    end

    if root then
      on_dir(root)
    end
  end,

  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = "Organize Imports",
    },
  },
}
