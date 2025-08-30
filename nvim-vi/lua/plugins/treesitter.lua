return {
  -- treesitter (support textobjects, required for jsx)
  -----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter-textobjects",
    -- },
    config = function()
      -- local config = require("nvim-treesitter.configs")
      -- config.setup({
      --   -- Add languages to be installed here that you want installed for treesitter
      --   ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'javascript', 'tsx', 'php', 'markdown', 'markdown_inline', 'sql', 'html', "http", "json" },
      --   auto_install = true,
      --   highlight = { enable = true },
      --   indent = { enable = true },
      --   incremental_selection = {
      --     enable = true,
      --     keymaps = {
      --       init_selection = '<c-.>',
      --       node_incremental = '<c-.>',
      --       scope_incremental = '<c-m>',
      --       node_decremental = '<c-,>',
      --     },
      --   },
      --   textobjects = {
      --     select = {
      --       enable = true,
      --       lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      --       keymaps = {
      --         -- You can use the capture groups defined in textobjects.scm
      --         ['aa'] = '@parameter.outer',
      --         ['ia'] = '@parameter.inner',
      --         ['af'] = '@function.outer',
      --         ['if'] = '@function.inner',
      --         ['ac'] = '@class.outer',
      --         ['ic'] = '@class.inner',
      --       },
      --     },
      --     move = {
      --       enable = true,
      --       set_jumps = true, -- whether to set jumps in the jumplist
      --       goto_next_start = {
      --         [']m'] = '@function.outer',
      --         [']]'] = '@class.outer',
      --       },
      --       goto_next_end = {
      --         [']M'] = '@function.outer',
      --         [']['] = '@class.outer',
      --       },
      --       goto_previous_start = {
      --         ['[m'] = '@function.outer',
      --         ['[['] = '@class.outer',
      --       },
      --       goto_previous_end = {
      --         ['[M'] = '@function.outer',
      --         ['[]'] = '@class.outer',
      --       },
      --     },
      --     swap = {
      --       enable = true,
      --       swap_next = {
      --         ['<leader>a'] = '@parameter.inner',
      --       },
      --       swap_previous = {
      --         ['<leader>A'] = '@parameter.inner',
      --       },
      --     },
      --   },
      -- })

      -- Diagnostic keymaps
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
    end
  },
}
