return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		})

		-- Open Oil in the current window
		vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", {
			desc = "Open Oil file explorer",
			silent = true,
		})
	end,
}
