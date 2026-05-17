return {
	cmd = {
		vim.fn.stdpath("data") .. "/mason/bin/gofumpt",
	},
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
}
