return {
	{
		"andymass/vim-matchup",
		opts = {},
		config = function()
			vim.g.matchup_matchperen_offscreen = {
				method = "popup",
				fullwidth = 1,
				highlight = "Normal",
				syntax_hl = 1,
				scrolloff = 2
			}
		end,
	},
}
