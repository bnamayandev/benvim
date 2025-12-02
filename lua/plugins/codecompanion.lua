return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		local cc = require("codecompanion")

		cc.setup({
			-- NEW STYLE: adapters.http.<name>
			adapters = {
				http = {
					openai = function()
						return require("codecompanion.adapters").extend("openai", {
							-- where to get your key from
							env = {
								api_key = vim.env.OPENAI_API_KEY, -- export OPENAI_API_KEY=...
							},
							-- defaults for this adapter
							schema = {
								model = {
									-- pick whatever you like here
									default = "gpt-4.1-mini",
								},
							},
						})
					end,
				},
			},

			-- Which adapter/model each strategy uses
			strategies = {
				chat = {
					adapter = "openai",
					-- optional: override model at strategy level
					-- model = "gpt-4.1-mini",
				},
				inline = {
					adapter = "openai",
				},
				agent = {
					adapter = "openai",
				},
			},

			-- misc options (all optional)
			opts = {
				-- "INFO" is fine once things work; use "DEBUG" if something breaks
				log_level = "ERROR",
				language = "English",
			},
		})

		-- simple keymaps (you can move these to your keymaps.lua if you prefer)
		vim.keymap.set("n", "<leader>ac", function()
			require("codecompanion").chat()
		end, { desc = "CodeCompanion Chat" })

		vim.keymap.set({ "n", "v" }, "<leader>ai", function()
			require("codecompanion").inline()
		end, { desc = "CodeCompanion Inline Edit" })

		vim.keymap.set({ "n", "v" }, "<leader>aa", function()
			require("codecompanion").actions()
		end, { desc = "CodeCompanion Action Palette" })
	end,
}
