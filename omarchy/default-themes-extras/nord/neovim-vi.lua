return {
  "EdenEast/nightfox.nvim",
  name = "nightfox",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("nightfox").setup(opts)
    pcall(vim.cmd.colorscheme, "nightfox")
  end,
}
