return {
  -- Show colors as background
  ----------------------------
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      vim.o.termguicolors = true
      require("nvim-highlight-colors").setup()
    end,
  },

  -- Surround
  -----------
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- handle persistent undo visually
  ----------------------------------
  {
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>")
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  ----------------------------------------------
  {
    "tpope/vim-sleuth",
  },

  -- html template system
  -----------------------
  {
    "mustache/vim-mustache-handlebars",
  },
}
