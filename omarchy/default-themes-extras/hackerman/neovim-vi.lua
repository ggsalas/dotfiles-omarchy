return {
  "bjarneo/hackerman.nvim",
  name = "hackerman",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.o.background = "dark" -- Set before setup for light mode
    pcall(vim.cmd.colorscheme, "hackerman")
  end,
}
