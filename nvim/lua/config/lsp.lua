-- [[ LSP starter ]]
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local lsp_server = {}
for name, type in vim.fs.dir(lsp_dir) do
	if type == "file" and name:match("%.lua$") then
		lsp_server[#lsp_server + 1] = name:gsub("%.lua$", "")
	end
end
vim.lsp.enable(lsp_server)

-- [[ LSP config ]]
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
		map("gld", vim.diagnostic.setloclist, "[L]ist [D]iagnostics")
		map("]d", vim.diagnostic.goto_next, "Goto next [D]iagnostics")
		map("[d", vim.diagnostic.goto_prev, "Goto prev [D]iagnostics")
	end,
})
