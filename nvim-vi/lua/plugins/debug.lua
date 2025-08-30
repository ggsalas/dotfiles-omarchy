return {
  -- Debug Adapter Protocol for Neovim
  ------------------------------------
  {
    "mfussenegger/nvim-dap",
    event = 'VeryLazy',
    config = function()
      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          }
        }
      end

      vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'GitSignsAdd', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = ' ', texthl = 'GitSignsAdd', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = ' ', texthl = 'GitSignsChange', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'GitSignsDelete', linehl = '', numhl = '' })
    end
  },

  -- UI interface for debug
  -------------------------
  {
    "rcarriga/nvim-dap-ui",
    event = 'VeryLazy',
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dapui_widgets = require('dap.ui.widgets')

      dapui.setup({
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = " ",
            pause = "",
            play = "",
            step_over = "",
            step_back = "",
            step_into = "",
            step_out = "",
            run_last = "↻",
            terminate = ""
          }
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "single",
          mappings = {
            close = { "q", "<Esc>" }
          }
        },
        force_buffers = true,
        icons = {
          collapsed = "▶",
          current_frame = "",
          expanded = "▼"
        },
        layouts = {
          {
            elements = {
              { id = "breakpoints", size = 0.30 },
              { id = "watches",     size = 0.30 },
              { id = "stacks",      size = 0.20 },
              { id = "console",     size = 0.20 }, -- don't know what is for yet
            },
            position = "right",
            size = 50
          },
          {
            elements = { { id = "repl", size = 1 } },
            position = "bottom",
            size = 10
          }
        },
        mappings = {
          edit = "e",
          expand = { "<2-LeftMouse>", "o" },
          open = "<CR>",
          remove = "d",
          repl = "r",
          toggle = "t"
        },
        render = {
          indent = 1,
          max_value_lines = 100
        }
      })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end

      -- mappings
      vim.keymap.set('n', '<leader>de', require 'dapui'.toggle)
      vim.keymap.set('n', '<leader>ded', dap.disconnect)

      vim.keymap.set('n', '<leader>dj', function() dap.continue() end)
      vim.keymap.set('n', '<Leader>dh', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>dH', function() dap.set_breakpoint(vim.fn.input('Condition: '), nil, nil) end)
      vim.keymap.set({ 'v', 'n' }, '<leader>dk', function() dapui.eval(nil, { enter = true }) end)
      vim.keymap.set({ 'n', 'v' }, '<Leader>dK', function() dapui_widgets.hover() end)
      vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
      vim.keymap.set('n', '<Leader>d;', function() dapui_widgets.centered_float(widgets.scopes) end)

      vim.keymap.set('n', '<leader>d<down>', function() dap.step_into() end)  -- ↓
      vim.keymap.set('n', '<leader>d<up>', function() dap.step_out() end)     -- 
      vim.keymap.set('n', '<leader>d<right>', function() dap.step_over() end) -- ->
      vim.keymap.set('n', '<leader>d<left>', function() dap.step_back() end)  -- <-
    end
  },

  -- DAP-based JavaScript debugger
  --------------------------------
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },

  -- nvim-dap adapter for vscode-js-debug
  ---------------------------------------
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    config = function()
      require("dap-vscode-js").setup({
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      })
    end
  },
}
