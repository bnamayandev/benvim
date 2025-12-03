vim.keymap.set("n", "<leader>gv", ":vsplit<CR>", { desc = "Vertical split" })

-- open terminal
vim.keymap.set("n", "<leader>t", function()
	vim.cmd("vsplit | term")
end)
-- In terminal mode, Ctrl-q closes the terminal window instantly
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
