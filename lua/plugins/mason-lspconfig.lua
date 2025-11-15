return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"pyright",
				"lua_ls",
				"clangd",
				"jdtls",
				"rust_analyzer",
				"omnisharp",
			},
			automatic_installation = true,
		})
	end,
}
