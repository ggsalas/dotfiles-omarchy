return {
  "kepano/flexoki-neovim",
  name = "flexoki-light",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.o.background = "light" -- Set before setup for light mode
  end,
}
