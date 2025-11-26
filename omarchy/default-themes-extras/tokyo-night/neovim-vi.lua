return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  name = "tokyonight",
  opts = {},
  config = function(opts)
    vim.opt.background = "dark"
  end,
}
