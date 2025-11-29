return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("catppuccin").setup(opts)
    pcall(vim.cmd.colorscheme, "catppuccin")
  end,
}
