return {
  "tahayvr/matteblack.nvim",
  lazy = false,
  priority = 1000,
  name = "matteblack",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"
    pcall(vim.cmd.colorscheme, "matteblack")
  end,
}
