return {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
  name = "everforest",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("everforest").setup(opts)
    pcall(vim.cmd.colorscheme, "everforest")
  end,
}
