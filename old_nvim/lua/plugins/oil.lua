return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      view_options = {
        show_hidden = true
      }
    },
  }
}
