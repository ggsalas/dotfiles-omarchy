return {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
  name = "everforest",
  opts = {},
  config = function(opts)
    vim.opt.background = "dark"

    require("everforest").setup(opts)
  end,
}
