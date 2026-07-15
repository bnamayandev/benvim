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

		local opts = { kind = "split_left_most" }

		local function close_finder(attempt)
			local finder = require("fyler.finder")
			local inst = finder.instance_get_or_nil()
			if not inst then
				return
			end

			if inst._is_refreshing and (attempt or 0) < 50 then
				vim.defer_fn(function()
					close_finder((attempt or 0) + 1)
				end, 20)
				return
			end

			inst:close()
		end

		local function open_finder()
			local finder = require("fyler.finder")
			local inst = finder.instance_get(nil, opts)
			inst._is_refreshing = false
			inst._refresh_again_with_args = nil
			inst:open()
		end

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = vim.api.nvim_create_augroup("FylerCloseOnFileOpen", { clear = true }),
			callback = function(args)
				local inst = require("fyler.finder").instance_get_or_nil()
				if not inst then
					return
				end

				local win = vim.api.nvim_get_current_win()
				if win == inst.win_id then
					return
				end
				if vim.api.nvim_win_get_config(win).relative ~= "" then
					return
				end
				if vim.bo[args.buf].buftype ~= "" or vim.api.nvim_buf_get_name(args.buf) == "" then
					return
				end

				vim.schedule(function()
					close_finder()
				end)
			end,
		})

		vim.keymap.set("n", "<leader>e", function()
			if vim.bo.filetype == "fyler_finder" then
				close_finder()
			else
				open_finder()
			end
		end, {
			desc = "Open Fyler",
			silent = true,
		})
	end,
}
