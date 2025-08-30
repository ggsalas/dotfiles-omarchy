return {
  -- Git for vim
  --------------
  {
    "tpope/vim-fugitive",
  },

  -- same as before... chose one
  {
    "sindrets/diffview.nvim",
    event = 'VeryLazy',
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed"
          }
        }
      })
    end
  },

  -- Enables GBrowse and completions for commit messages
  ------------------------------------------------------
  {
    "tpope/vim-rhubarb",
  },

  -- git decorations
  ------------------
  {
    "lewis6991/gitsigns.nvim",
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map('n', '<leader>ca', gs.stage_hunk)
          map('n', '<leader>cd', gs.reset_hunk)
          map('v', '<leader>ca', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('v', '<leader>cd', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('n', '<leader>cu', gs.undo_stage_hunk)
          map('n', '<leader>cp', gs.preview_hunk)
          map('n', '<leader>cb', function() gs.blame_line { full = true } end)
          -- map('n', '<leader>tb', gs.toggle_current_line_blame)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  }
}
