local lsp_utils = require("utils.lsp")
local lsp_server = lsp_utils.get_lsp_servers()
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = lsp_server,
    }
  }
}
