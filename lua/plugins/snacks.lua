return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		picker = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		image = { enabled = true },
		quickfile = { enabled = true },
		indent = { enabled = true },
		scroll = { enabled = true },
		words = { enabled = true },
		statuscolumn = { enabled = true },
	},

	keys = {
		{
			"<leader><leader>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Snacks)",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep (Snacks)",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers (Snacks)",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags (Snacks)",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History (Snacks)",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
	},
}
