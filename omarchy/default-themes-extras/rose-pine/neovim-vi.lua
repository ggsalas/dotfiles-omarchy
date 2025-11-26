return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine-dawn",
  opts = {
    variant = "dawn", -- auto, main, moon, or dawn
    dark_variant = "down", -- main, moon, or dawn
  },
  config = function(opts)
    vim.opt.background = "light"

    require("rose-pine").setup(opts)
  end,
}
