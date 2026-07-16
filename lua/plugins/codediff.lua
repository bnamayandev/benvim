return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	opts = {
		diff = {
			ignore_trim_whitespace = true,
			compute_moves = true,
			cycle_hunks_across_files = true,
		},
		keymaps = {
			view = {
				next_hunk = "<leader>n",
				prev_hunk = "<leader>N",
			},
		},
	},
	keys = {
		{
			"<leader>cs",
			"<cmd>CodeDiff<CR>",
			desc = "Diff all changed files",
		},
		{
			"<leader>cd",
			function()
				local lifecycle = require("codediff.ui.lifecycle")
				for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
					if lifecycle.get_session(tab) then
						vim.api.nvim_set_current_tabpage(tab)
						vim.cmd("CodeDiff")
						return
					end
				end
				vim.cmd("CodeDiff file HEAD")
			end,
			desc = "Toggle diff of current file against HEAD",
		},
		{
			"<leader>cm",
			function()
				local file = vim.fn.expand("%:p")
				if file == "" then
					vim.notify("No file in buffer", vim.log.levels.WARN)
					return
				end
				vim.cmd("CodeDiff merge " .. vim.fn.fnameescape(file))
			end,
			desc = "Resolve merge conflicts in current file",
		},
		{
			"<leader>cr",
			function()
				local file = vim.fn.expand("%:p")
				if file == "" then
					vim.notify("No file in buffer", vim.log.levels.WARN)
					return
				end

				local git = require("codediff.core.git")
				local root = git.get_git_root_sync(file)
				if not root then
					vim.notify("Not in a git repository", vim.log.levels.ERROR)
					return
				end

				local rel = file:gsub("\\", "/"):sub(#root + 2)
				if vim.fn.confirm("Discard working tree changes to " .. rel .. "?", "&Yes\n&No", 2) ~= 1 then
					return
				end

				git.restore_file(root, rel, function(err)
					if err then
						vim.notify(err, vim.log.levels.ERROR)
						return
					end
					vim.cmd("checktime")
					vim.notify("Reverted " .. rel)
				end)
			end,
			desc = "Revert current file",
		},
	},
}
