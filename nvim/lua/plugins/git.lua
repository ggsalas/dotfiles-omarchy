return {
  -- Git for vim
  --------------
  {
    "tpope/vim-fugitive",
  },

  -- Enables GBrowse and completions for commit messages
  ------------------------------------------------------
  {
    "tpope/vim-rhubarb",
  },

  -- GDiffBranch: compare current branch against another branch using quickfix + fugitive
  -- Usage: :GDiffBranch [branch]  (defaults to main or master)
  -- Keymap: <leader>gd
  -- In quickfix: dd = open diff, <CR> = open file
  {
    "tpope/vim-fugitive",
    config = function()
      local function detect_base_branch()
        local result = vim.fn.system("git branch --list main master")
        if result:match("main") then
          return "main"
        end
        return "master"
      end

      -- to return filename only
      function DiffBranchQfText(info)
        local items = vim.fn.getqflist({ id = info.id, items = 1 }).items
        local lines = {}
        for i = info.start_idx, info.end_idx do
          table.insert(lines, vim.fn.bufname(items[i].bufnr))
        end
        return lines
      end

      -- to only have diff (or file) and qfix windows
      local function prepare_main_window()
        local wins = vim.api.nvim_list_wins()
        local other_wins = {} -- no quickfix windows

        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype ~= "quickfix" then
            table.insert(other_wins, win)
          end
        end

        local main_win = other_wins[1]
        if not main_win then
          vim.cmd("above new")
          main_win = vim.api.nvim_get_current_win()
        else
          for i = 2, #other_wins do
            pcall(vim.api.nvim_win_close, other_wins[i], true)
          end
        end

        vim.api.nvim_set_current_win(main_win)
        vim.cmd("diffoff")
      end

      -- to get filename under cursor
      local function get_qf_filename()
        local lnum = vim.fn.line(".")
        local qflist = vim.fn.getqflist()
        local entry = qflist[lnum]
        if not entry then
          return nil
        end
        local filename = vim.fn.bufname(entry.bufnr)
        if filename == "" then
          return nil
        end
        return filename
      end

      vim.api.nvim_create_user_command("GDiffBranch", function(opts)
        local branch = opts.args ~= "" and opts.args or detect_base_branch()
        local output = vim.fn.systemlist("git diff --name-only " .. vim.fn.shellescape(branch))

        if vim.v.shell_error ~= 0 then
          vim.notify("Error running git diff against " .. branch, vim.log.levels.ERROR)
          return
        end

        if #output == 0 or (output[1] and output[1] == "") then
          vim.notify("No changes compared to " .. branch, vim.log.levels.INFO)
          return
        end

        local items = {}
        for _, file in ipairs(output) do
          if file ~= "" then
            table.insert(items, { filename = file })
          end
        end

        vim.fn.setqflist({}, " ", {
          title = "DiffBranch: " .. branch,
          items = items,
          quickfixtextfunc = "v:lua.DiffBranchQfText",
        })
        vim.cmd("copen")
        vim.b.diff_branch = branch
      end, { nargs = "?", desc = "Show files changed compared to a branch" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.schedule(function()
            local branch = vim.b.diff_branch
            if not branch then
              return
            end

            vim.keymap.set("n", "dd", function()
              local filename = get_qf_filename()
              if not filename then
                return
              end

              prepare_main_window()
              vim.cmd("edit " .. vim.fn.fnameescape(filename))
              vim.cmd("Gvdiffsplit " .. branch .. ":%")
              vim.cmd("wincmd l")
            end, { buffer = true, desc = "Diff against " .. branch })

            vim.keymap.set("n", "<CR>", function()
              local filename = get_qf_filename()
              if not filename then
                return
              end

              prepare_main_window()
              vim.cmd("edit " .. vim.fn.fnameescape(filename))
            end, { buffer = true, desc = "Open file" })
          end)
        end,
      })

      vim.keymap.set("n", "<leader>gd", ":GDiffBranch<CR>", { silent = true, desc = "Diff against base branch" })
    end,
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
