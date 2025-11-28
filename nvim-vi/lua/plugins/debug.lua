return {
  -- Debug Adapter Protocol for Neovim
  ------------------------------------
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
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
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Breakpoint signs with Nerd Font icons
      vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "󰛿", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "󰟃", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰁔", texthl = "DiagnosticHint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "󰅖", texthl = "DiagnosticError", linehl = "", numhl = "" })
    end,
  },

  -- UI interface for debug
  -------------------------
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dapui_widgets = require("dap.ui.widgets")

      dapui.setup({
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = "󰖷",
            pause = "󰏤",
            play = "󰐊",
            run_last = "󰑙",
            step_back = "󰜱",
            step_into = "󰆹",
            step_out = "󰆸",
            step_over = "󰆷",
            terminate = "󰝤",
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = "󰅂",
          current_frame = "󰁔",
          expanded = "󰅀",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      })

      -- Auto open/close dapui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>de", dapui.toggle, { desc = "Debug: Toggle UI" })
      vim.keymap.set("n", "<leader>ded", dap.disconnect, { desc = "Debug: Disconnect" })

      vim.keymap.set("n", "<leader>dj", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<leader>dh", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dH", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional breakpoint" })
      
      vim.keymap.set({ "n", "v" }, "<leader>dk", function()
        dapui.eval(nil, { enter = true })
      end, { desc = "Debug: Eval" })
      
      vim.keymap.set({ "n", "v" }, "<leader>dK", dapui_widgets.hover, { desc = "Debug: Hover" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
      
      vim.keymap.set("n", "<leader>d;", function()
        dapui_widgets.centered_float(dapui_widgets.scopes)
      end, { desc = "Debug: Scopes" })

      -- Step controls
      vim.keymap.set("n", "<leader>d<down>", dap.step_into, { desc = "Debug: Step into" })
      vim.keymap.set("n", "<leader>d<up>", dap.step_out, { desc = "Debug: Step out" })
      vim.keymap.set("n", "<leader>d<right>", dap.step_over, { desc = "Debug: Step over" })
      vim.keymap.set("n", "<leader>d<left>", dap.step_back, { desc = "Debug: Step back" })
    end,
  },

  -- DAP-based JavaScript debugger
  --------------------------------
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },

  -- nvim-dap adapter for vscode-js-debug
  ---------------------------------------
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/vscode-js-debug",
    },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
    end,
  },
}
