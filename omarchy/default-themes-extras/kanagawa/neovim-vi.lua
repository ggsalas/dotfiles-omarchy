return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("kanagawa").setup(opts)
    pcall(vim.cmd.colorscheme, "kanagawa")
  end,
}
