return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  name = "bamboo",
  opts = {},
  config = function(opts)
    vim.opt.background = "dark"

    require("bamboo").setup(opts)
    require("bamboo").load()
  end,
}
