return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin-latte",
  opts = {
    flavour = "latte",
  },
  config = function(_, opts)
    vim.opt.background = "light"

    require("catppuccin").setup(opts)
    pcall(vim.cmd.colorscheme, "catppuccin-latte")
  end,
}
