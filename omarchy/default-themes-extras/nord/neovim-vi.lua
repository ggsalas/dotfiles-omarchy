return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  name = "nightfox",
  opts = {},
  config = function(opts)
    vim.opt.background = "dark"

    require("nightfox").setup(opts)
  end,
}
