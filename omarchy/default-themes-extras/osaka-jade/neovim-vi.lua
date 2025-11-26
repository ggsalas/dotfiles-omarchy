return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  name = "bamboo",
  opts = {},
  config = function(_, opts)
    vim.opt.background = "dark"

    require("bamboo").setup(opts)
    require("bamboo").load()
    -- pcall(vim.cmd.colorscheme, "bamboo")
  end,
}
