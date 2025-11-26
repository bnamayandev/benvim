return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local oil = require("oil")

		oil.setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		})

		-- Open Oil and automatically enable preview
		vim.keymap.set("n", "<leader>e", function()
			oil.open()
			-- Wait until Oil has finished setting up, then trigger preview
			vim.schedule(function()
				local ok, actions = pcall(require, "oil.actions")
				if ok and actions.preview then
					actions.preview.callback()
				end
			end)
		end, {
			desc = "Open Oil with preview",
			silent = true,
		})
	end,
}
