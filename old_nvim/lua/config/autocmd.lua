-- Lsp reset

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

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Terminal
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	pattern = "*",
	callback = function(args)
		vim.api.nvim_buf_call(args.buf, function()
			vim.cmd("startinsert")
			vim.cmd("setlocal nonumber norelativenumber")
		end)
	end,
})
