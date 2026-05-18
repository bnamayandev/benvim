return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"pyright",
			"clangd",
			"rust_analyzer",
			"omnisharp",
			"gopls",
			"ts_ls",
		},
		automatic_installation = true,
	},
}
