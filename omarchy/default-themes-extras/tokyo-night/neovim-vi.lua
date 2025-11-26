return {
  name = "tokyonight",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"
    pcall(vim.cmd.colorscheme, "tokyonight")
  end,
}
