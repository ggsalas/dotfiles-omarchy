return {
  "nvim-lua/lsp-status.nvim",

  config = function()
    local lsp_status = require('lsp-status')

    lsp_status.register_progress()

    lsp_status.config {
      select_symbol = function(cursor_pos, symbol)
        if symbol.valueRange then
          local value_range = {
            ['start'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
            ['end'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
          }

          return require('lsp-status.util').in_range(cursor_pos, value_range)
        end
      end,

      indicator_errors = '✖',
      indicator_warnings = '',
      indicator_info = 'ℹ',
      indicator_hint = '',
      indicator_ok = ' ',
      status_symbol = ' ',
    }


    -- Custom statusline
    --------------------
    local function statusline()
      -- save this function in global scope 
      function vim.g.get_lsp_status()
        if #vim.lsp.buf_get_clients() > 0 then
          return require('lsp-status').status()
        else
          return " "
        end
      end

      local file_and_modified = '%f %m'
      local align_right = '%='
      local status = '%{%g:get_lsp_status()%}' -- return the function from global scope

      vim.opt.statusline = file_and_modified .. align_right .. status
    end

    statusline()
  end
}
