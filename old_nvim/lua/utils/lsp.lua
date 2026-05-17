local M = {}

function M.get_lsp_servers()
	local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
	local lsp_server = {}
	for name, type in vim.fs.dir(lsp_dir) do
		if type == "file" and name:match("%.lua$") then
			lsp_server[#lsp_server + 1] = name:gsub("%.lua$", "")
		end
	end
  return lsp_server
end

return M
