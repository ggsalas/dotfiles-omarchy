return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(opts)
    vim.opt.background = "dark"

    require("catppuccin").setup(opts)
  end,
}
