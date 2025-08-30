return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require 'telescope.actions'
      local finders = require 'telescope.finders'
      local pickers = require 'telescope.pickers'
      local conf = require('telescope.config').values
      local utils = require('telescope.utils')
      local builtin = require('telescope.builtin')
      local themes = require('telescope.themes')
      local action_state = require('telescope.actions.state')

      require("telescope").setup({
        defaults = {
          file_sorter = require('telescope.sorters').get_fzy_sorter,
          prompt_prefix = '  ',
          selection_caret = '❯ ',
          disable_devicons = true, -- seems is not detected as default, added on each function
          layout_strategy = 'vertical',
          layout_config = { horizontal = { preview_width = 0.3 }, vertical = { preview_height = 0.6 } },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<esc>'] = actions.close,
              ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
              ['<cr>'] = actions.select_default + actions.center,
            },
            n = {
              ['<C-w>'] = actions.send_selected_to_qflist,
              ['<C-q>'] = actions.send_to_qflist,
              ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
            },
          },
        },
        pickers = {
          lsp_references = {
            show_line = false,
          },
        },
        extensions = {
          ['ui-select'] = {
            themes.get_dropdown {},
          },
        },
      })

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      -- Enable handling for code actions
      require('telescope').load_extension 'ui-select'

      -- Custom Picker
      ----------------
      local dot_files = function(opts)
        opts = opts or {}
        local job_command = vim.tbl_flatten({
          'sh',
          '-c',
          'git --git-dir $HOME/.dotfiles/ ls-files --full-name | sed "s,^,$HOME/,"'
        })
        local finder = finders.new_oneshot_job(job_command)
        local previewer = conf.file_previewer(opts)
        local sorter = conf.file_sorter(opts)

        pickers.new(opts, {
          prompt_title = 'DotFiles',
          finder = finder,
          previewer = previewer,
          sorter = sorter,
        }):find()
      end

      -- Custom actions
      -----------------
      local find_files_current_dir = function()
        local dir = utils.buffer_dir()

        builtin.git_files({
          prompt_title = string.format('Find files the Current Dir (%s)', dir),
          cwd = dir,
          disable_devicons = true
        })
      end

      local grep_current_dir = function()
        local dir = utils.buffer_dir()

        builtin.live_grep({
          prompt_title = string.format('Grep in the Current Dir (%s)', dir),
          cwd = dir,
          disable_devicons = true,
          only_sort_text = true,
          use_regex = false,
          disable_coordinates = true,
        })
      end

      local live_grep = function()
        builtin.live_grep({
          prompt_title = string.format('Grep in the local in Dir', utils.buffer_dir()),
          disable_devicons = true,
          only_sort_text = true,
          use_regex = false,
          disable_coordinates = true,
        })
      end

      local grep_string = function()
        builtin.live_grep({
          default_text = vim.fn.expand("<cword>"),
          disable_devicons = true,
          only_sort_text = true,
          use_regex = false,
          disable_coordinates = true,
        })
      end

      local buffer_list = function()
        local width_padding = function()
          local cols = vim.o.columns
          -- print(vim.inspect(cols))

          if cols < 80 then
            return .9
          elseif cols < 150 then
            return 0.8
          else
            return 0.7
          end
        end

        local wp = width_padding()

        builtin.buffers {
          sort_lastused = true,
          show_all_buffers = true,
          disable_devicons = true,
          previewer = false,
          width_padding = wp,
          layout_strategy = 'vertical',
          layout_config = { width = wp, height = .55 },
          attach_mappings = function(prompt_bufnr, map)
            local delete_buf = function()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local multi_selections = current_picker:get_multi_selection()

              if next(multi_selections) == nil then
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              else
                actions.close(prompt_bufnr)
                for _, selection in ipairs(multi_selections) do
                  vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                end
              end
            end

            map('i', '<C-x>', delete_buf)
            return true
          end
        }
      end

      local search_dot_files = function()
        dot_files({
          previewer = false,
        })
      end

      local search_notes = function()
        builtin.find_files({
          prompt_title = "Notes",
          cwd = "~/Google Drive/My Drive/Notas/",
          disable_devicons = true,
        })
      end


      -- Mappings
      -----------

      -- files & grep
      vim.keymap.set('n', '<leader>l', builtin.diagnostics, { desc = 'Search [L]inter' })
      vim.keymap.set('n', '<leader>j', buffer_list)
      vim.keymap.set('n', '<leader>f', builtin.git_files)
      vim.keymap.set('n', '<leader>s', live_grep, { desc = 'Grep in the Main Dir' })
      vim.keymap.set('n', '<leader>df', find_files_current_dir)
      vim.keymap.set('n', '<leader>ds', grep_current_dir, { desc = 'Grep in the Current Dir' })
      vim.keymap.set('n', '<leader>*', grep_string, { desc = 'Grep word under cursor' })

      vim.keymap.set('n', '<leader>gs', builtin.git_stash)
      vim.keymap.set('n', '<leader>gb', builtin.git_branches)
      vim.keymap.set('n', '<leader>gc', builtin.git_bcommits)
      vim.keymap.set('n', '<leader>gC', builtin.git_commits)
      vim.keymap.set('n', '<leader>gf', builtin.git_status)

      -- vim
      vim.keymap.set(
        'n',
        '<leader>gh',
        function() builtin.help_tags({ prompt_title = 'Search Vim Help' }) end
      )
      vim.keymap.set(
        'n',
        '<leader>gn',
        function() builtin.man_pages({ prompt_title = 'Search Man Pages' }) end
      )
      vim.keymap.set(
        'n',
        '<leader>gm',
        function() builtin.marks({ prompt_title = 'Search Marks' }) end
      )
      vim.keymap.set(
        'n',
        '<leader>gq',
        function() builtin.quickfix({ prompt_title = 'Search QuickFix list' }) end
      )
      vim.keymap.set(
        'n',
        '<leader>z',
        function() builtin.spell_suggest(themes.get_dropdown({ prompt_title = 'Spell Suggestions' })) end
      )
      vim.keymap.set('n', '<leader>gk', builtin.keymaps)
      vim.keymap.set('n', '<leader>do', search_dot_files)

      vim.api.nvim_create_user_command('Notes', search_notes, {})
      vim.api.nvim_create_user_command('NotesFolder', "e ~/Google Drive/My\\ Drive/Notas/", {})
    end,
  },
}
