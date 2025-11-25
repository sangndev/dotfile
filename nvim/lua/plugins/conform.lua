return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
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
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range" })
		end,
	},
}
