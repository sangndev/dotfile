return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("vscode.colors").get_colors()
			require("vscode").setup({
				transparent = true,
				italic_comments = true,
				underline_links = true,
				disable_nvimtree_bg = true,
				group_overrides = {
					Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
					EndOfBuffer = { fg = c.vscBack },
					CursorLine = { bg = c.vscCursorDark },
					CursorColumn = { fg = "NONE", bg = c.vscCursorDark },
					ColorColumn = { fg = "NONE", bg = c.vscCursorDark },
					GitSignsCurrentLineBlame = { fg = c.vscCursorLight },
					StatusLine = { bg = "NONE" },
				},
			})
			vim.api.nvim_exec(
				[[
            set termguicolors
            colorscheme vscode
          ]],
				false
			)
		end,
	},
}
