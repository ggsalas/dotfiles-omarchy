return {
  -- Simple presentation (slides) tool
  -- Evaluate more complex ones here: https://youtu.be/owx5KoiqFBs
  ----------------------------------------------------------------
  {
    "sotte/presenting.vim",
    event = 'VeryLazy',
    config = function()
      vim.g.presenting_top_margin = 0
      vim.g.presenting_quit = 'q'
      vim.g.presenting_next = '<Right>'
      vim.g.presenting_prev = '<Left>'
    end
  },

  -- Nice drawings tool
  ---------------------
  {
    "jbyuki/venn.nvim",
    event = 'VeryLazy',
    config = function()
      local function drawStart()
        vim.o.virtualedit = 'all'
        vim.o.cursorcolumn = true
      end

      local function drawStop()
        vim.o.virtualedit = ''
        vim.o.cursorcolumn = false
      end

      vim.api.nvim_create_user_command('DrawStart', drawStart, {})
      vim.api.nvim_create_user_command('DrawStop', drawStop, {})
      vim.keymap.set('v', '.', ':VBox<cr>')
    end
  },

}
