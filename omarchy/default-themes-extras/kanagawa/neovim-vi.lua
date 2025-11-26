return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  name = "kanagawa",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("kanagawa").setup(opts)
    pcall(vim.cmd.colorscheme, "kanagawa")
  end,
}
