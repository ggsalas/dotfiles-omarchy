return {
  "windwp/nvim-spectre",
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', '<leader>S', require('spectre').open)

    -- search current word
    vim.keymap.set('n', '<leader>Sw', function()
      require('spectre').open_visual { select_word = true }
    end)
    vim.keymap.set('v', '<leader>S', require('spectre').open_visual)
  end
}
