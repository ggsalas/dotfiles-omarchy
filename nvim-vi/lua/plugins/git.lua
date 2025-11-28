return {
  -- Git for vim
  --------------
  {
    "tpope/vim-fugitive",
  },

  -- same as before... chose one
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      })
    end,
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
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        attach_to_untracked = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Helper function para navegar y mostrar menú
          local function navigate_hunk_with_menu(direction)
            local navigate = direction == "next" and gs.next_hunk or gs.prev_hunk

            vim.schedule(function()
              -- Guardar posición actual
              local current_line = vim.api.nvim_win_get_cursor(0)[1]

              navigate()

              -- Check if a hunk has been navigated
              vim.defer_fn(function()
                local new_line = vim.api.nvim_win_get_cursor(0)[1]

                -- If hunk has found, show preview
                if new_line ~= current_line then
                  gs.preview_hunk_inline()

                  vim.defer_fn(function()
                    local choice = vim.fn.confirm("Hunk action:", "&Stage hunk\n&Reset hunk\n&Undo stage\n&Close", 1)

                    if choice == 1 then
                      gs.stage_hunk()
                    elseif choice == 2 then
                      gs.reset_hunk()
                    elseif choice == 3 then
                      gs.undo_stage_hunk()
                    elseif choice == 4 then
                      -- Clear inline preview
                      local ns = vim.api.nvim_create_namespace("gitsigns_preview_inline")
                      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                      -- Close any floating windows
                      vim.cmd("silent! fclose")
                    end
                  end, 100)
                end
              end, 50)
            end)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            navigate_hunk_with_menu("next")
            return "<Ignore>"
          end, { expr = true })
          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            navigate_hunk_with_menu("prev")
            return "<Ignore>"
          end, { expr = true })

          -- Actions menu
          map("n", "gm", function()
            local git_actions = {
              { title = "Stage hunk", action = gs.stage_hunk },
              { title = "Reset hunk", action = gs.reset_hunk },
              { title = "Preview hunk", action = gs.preview_hunk },
              { title = "Undo stage hunk", action = gs.undo_stage_hunk },
              {
                title = "Blame line",
                action = function()
                  gs.blame_line({ full = true })
                end,
              },
              { title = "Stage buffer", action = gs.stage_buffer },
              { title = "Reset buffer", action = gs.reset_buffer },
              { title = "Diff this", action = gs.diffthis },
              { title = "Toggle deleted", action = gs.toggle_deleted },
              { title = "Toggle line blame", action = gs.toggle_current_line_blame },
            }

            vim.ui.select(git_actions, {
              prompt = "Git actions:",
              format_item = function(item)
                return item.title
              end,
            }, function(selected)
              if selected then
                selected.action()
              end
            end)
          end, { desc = "Git actions menu" })
        end,
      })
    end,
  },
}
