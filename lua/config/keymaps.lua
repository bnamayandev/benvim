vim.keymap.set("n", "<leader>gv", ":vsplit<CR>", { desc = "Vertical split" })

local term_buf = nil
local term_win = nil

vim.keymap.set("n", "<leader>t", function()
   if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_hide(term_win)
      term_win = nil
      return
   end

   if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.cmd("vsplit")
      term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(term_win, term_buf)
      return
   end

   vim.cmd("vsplit")
   term_win = vim.api.nvim_get_current_win()
   vim.cmd("term")
   term_buf = vim.api.nvim_get_current_buf()
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
