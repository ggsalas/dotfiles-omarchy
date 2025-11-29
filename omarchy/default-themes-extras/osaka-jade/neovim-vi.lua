return {
  "ribru17/bamboo.nvim",
  name = "bamboo",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("bamboo").setup(opts)
    require("bamboo").load()
    -- pcall(vim.cmd.colorscheme, "bamboo")
  end,
}
