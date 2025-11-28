return {
  -- treesitter (support textobjects, required for jsx)
  -----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
    end,
  },
}
