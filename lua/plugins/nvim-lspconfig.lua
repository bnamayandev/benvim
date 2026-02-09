return {
	"neovim/nvim-lspconfig",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
			end

			map("gd", vim.lsp.buf.definition, "Goto definition")
			map("K", vim.lsp.buf.hover, "Hover")
			map("gr", vim.lsp.buf.references, "References")
			map("<leader>rn", vim.lsp.buf.rename, "Rename")
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
