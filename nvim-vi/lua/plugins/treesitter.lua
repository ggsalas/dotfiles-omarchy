return {
  -- treesitter (support textobjects, required for jsx)
  -----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Ensure these parsers are always installed
        ensure_installed = {
          "python",
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        highlight = {
          enable = true,
        },
      })

      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
    end,
  },
}
