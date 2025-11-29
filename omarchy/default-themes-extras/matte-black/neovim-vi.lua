return {
  "tahayvr/matteblack.nvim",
  name = "matteblack",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"
    pcall(vim.cmd.colorscheme, "matteblack")
  end,
}
