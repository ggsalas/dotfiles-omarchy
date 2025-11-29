return {
  "rose-pine/neovim",
  name = "rose-pine-dawn",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "dawn", -- auto, main, moon, or dawn
    dark_variant = "down", -- main, moon, or dawn
  },
  config = function(_, opts)
    vim.opt.background = "light"

    require("rose-pine").setup(opts)
    pcall(vim.cmd.colorscheme, "rose-pine-dawn")
  end,
}
