return {
  "bjarneo/ethereal.nvim",
  lazy = false,
  priority = 1000,
  name = "ethereal",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"
    pcall(vim.cmd.colorscheme, "ethereal")
  end,
}
