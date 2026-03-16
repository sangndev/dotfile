return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"typescript",
				"tsx",
				"javascript",
				"scss",
				"lua",
				"html",
				"json",
				"json5",
				"css",
				"go",
				"markdown",
				"http",
				"vim",
			},
			sync_install = false,
			highlight = { enable = true, additional_vim_regex_highlighting = true },
			indent = { enable = true },
			matchup = { enable = true },
		},
	},
}
