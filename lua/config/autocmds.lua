-- Automatically reload files changed outside of Neovim.
-- `autoread` marks buffers as needing a reload, but Neovim only acts on it
-- when certain events fire. These autocmds cover the common cases:
--   FocusGained / BufEnter  → switching back to the terminal / opening a buffer
--   CursorHold / CursorHoldI → after `updatetime` ms of inactivity
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
