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
