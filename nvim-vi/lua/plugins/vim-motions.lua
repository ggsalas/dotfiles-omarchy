return {
  -- better vim motions
  ---------------------
  "ggandor/leap.nvim",
  config = function()
    local leap = require('leap')

    leap.opts.labels = 'jhkl;fgdsauyiopmn,./rtewqvbcxz'

    -- TODO: Add vim colors without using base16
    -- -- Hide the (real) cursor when leaping, and restore it afterwards.
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'LeapEnter',
    --   callback = function()
    --     local guibg = "guibg=" .. require('base16-colorscheme').colors.base0F
    --     vim.cmd.hi('Cursor', 'blend=100', guibg)
    --     vim.opt.guicursor:append { 'a:Cursor/lCursor' }
    --   end,
    -- })
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'LeapLeave',
    --   callback = function()
    --     local guibg = "guibg=" .. require('base16-colorscheme').colors.base0F
    --     vim.cmd.hi('Cursor', 'blend=0', guibg)
    --     vim.opt.guicursor:remove { 'a:Cursor/lCursor' }
    --   end,
    -- })


    vim.keymap.set('n', 'f', '<Plug>(leap-forward-to)')
    vim.keymap.set('n', 't', '<Plug>(leap-forward-till)')
    vim.keymap.set('n', 'F', '<Plug>(leap-backward-to)')
    vim.keymap.set('n', 'T', '<Plug>(leap-backward-ill)')
    -- vim.keymap.set('n', 'gf', '<Plug>(leap-cross-window)')

    vim.keymap.set('n', 'gf', function()
      require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
    end)
  end
}
