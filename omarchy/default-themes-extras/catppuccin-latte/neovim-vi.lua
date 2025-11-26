return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin-latte",
  opts = {
    flavour = "latte",
  },
  config = function(opts)
    vim.opt.background = "light"

    require("catppuccin").setup(opts)
  end,
}
