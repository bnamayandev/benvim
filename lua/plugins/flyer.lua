return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	branch = "stable",
	lazy = false,
	opts = {
		views = {
			finder = {
				default_explorer = true,
				win = {
					kinds = {
						-- override just this kind
						split_left_most = {
							width = "20%", -- or "20%", "40%", etc
							win_opts = {
								winfixwidth = true,
							},
						},
					},
				},
			},
		},
	},
	config = function(_, opts)
		local fyler = require("fyler")
		fyler.setup(opts)

		vim.keymap.set("n", "<leader>e", function()
			fyler.open({ kind = "split_left_most" })
		end, { desc = "Open Fyler", silent = true })
	end,
}
