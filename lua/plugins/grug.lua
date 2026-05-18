return {
	"MagicDuck/grug-far.nvim",
	config = function()
		local grug = require("grug-far")

		grug.setup({})

		local function open_float(opts)
			local width = math.floor(vim.o.columns * 0.9)
			local height = math.floor(vim.o.lines * 0.85)
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
			})
			grug.open(vim.tbl_extend("force", {
				windowCreationCommand = "lua vim.api.nvim_set_current_win(vim.api.nvim_get_current_win())",
			}, opts or {}))
		end

		vim.keymap.set("n", "<leader>gr", function()
			open_float()
		end, { desc = "[S]earch [R]eplace (Grug)" })

		vim.keymap.set("n", "<leader>gR", function()
			open_float({ search = vim.fn.expand("<cword>") })
		end, { desc = "[S]earch [R]eplace word (Grug)" })

		vim.keymap.set("v", "<leader>gr", function()
			local save_reg = vim.fn.getreg('"')
			vim.cmd('normal! "vy')
			local text = vim.fn.getreg('"')
			vim.fn.setreg('"', save_reg)
			open_float({ search = text })
		end, { desc = "[S]earch [R]eplace selection (Grug)" })
	end,
}
