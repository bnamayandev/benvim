-- Automatically reload files changed outside of Neovim (e.g. by Claude Code).

-- 1. Event-based: catch focus/buffer switches immediately
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- 2. Timer-based: poll every 1000ms so edits appear in real-time even when
--    Neovim has focus and you haven't moved the cursor.
local uv = vim.uv or vim.loop
local timer = uv.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(function()
  if vim.fn.mode() ~= "c" then
    vim.cmd("checktime")
  end
end))
