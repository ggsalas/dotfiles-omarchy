return {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.o.background = "dark" -- Set before setup for light mode

    require("gruvbox").setup(opts)
    pcall(vim.cmd.colorscheme, "gruvbox")
  end,
}
