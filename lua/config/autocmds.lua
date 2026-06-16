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

local brave_group = vim.api.nvim_create_augroup("open_images_in_brave", { clear = true })
local image_exts = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "tif", "ico", "avif", "heic", "jxl" }
local image_patterns = {}
for _, ext in ipairs(image_exts) do
  image_patterns[#image_patterns + 1] = "*." .. ext
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = brave_group,
  pattern = image_patterns,
  callback = function(ev)
    local path = vim.fn.fnamemodify(ev.file, ":p")
    vim.fn.jobstart({ "brave-browser", path }, { detach = true })
    vim.notify("Opening " .. vim.fn.fnamemodify(path, ":t") .. " in Brave", vim.log.levels.INFO)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then
        return
      end
      for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
        vim.api.nvim_win_call(win, function()
          local alt = vim.fn.bufnr("#")
          if alt > 0 and alt ~= ev.buf and vim.api.nvim_buf_is_valid(alt) then
            vim.api.nvim_set_current_buf(alt)
          else
            vim.cmd("enew")
          end
        end)
      end
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
    end)
  end,
})
