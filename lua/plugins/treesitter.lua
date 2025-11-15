return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter not installed", vim.log.levels.WARN)
      return
    end

    configs.setup({
      ensure_installed = {
        "lua",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
