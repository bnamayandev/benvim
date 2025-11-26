return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			direction = "float",
		})

		local function toggle_term_with_count()
			local count = vim.v.count
			if count == 0 then
				vim.cmd("ToggleTerm")
			else
				vim.cmd(count .. "ToggleTerm")
			end
		end

		vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_term_with_count, {
			desc = "Toggle terminal (with count)",
		})
	end,
}
