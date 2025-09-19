return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
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
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true, window = { border = "rounded", show_documentation = false } },
		},
	},
}
