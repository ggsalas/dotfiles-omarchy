return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("catppuccin").setup(opts)
    pcall(vim.cmd.colorscheme, "catppuccin")
  end,
}
