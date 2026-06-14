return {
	"FylerOrg/fyler.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local fyler = require("fyler")

		fyler.setup({
			use_as_default_explorer = true,
			kind = "split_left_most",
			integrations = {
				icon = "nvim_web_devicons",
			},
			kind_presets = {
				split_left_most = {
					mappings = {
						n = {
							["<CR>"] = {
								action = function(self)
									local node = require("fyler.finder").parse_cursor_line(self)
									if not node or node.type == "directory" or node.type == "link" then
										self:select()
										return
									end
									self:close()
									vim.cmd.edit(vim.fn.fnameescape(node.link_target or node.full_path))
								end,
							},
						},
					},
				},
			},
		})

		vim.keymap.set("n", "<leader>e", function()
			if vim.bo.filetype == "fyler_finder" then
				local inst = require("fyler.finder").instance_get_or_nil()
				if inst then
					inst:close()
				end
			else
				fyler.open({ kind = "split_left_most" })
			end
		end, {
			desc = "Open Fyler",
			silent = true,
		})
	end,
}
