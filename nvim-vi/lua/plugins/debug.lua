return {
  -- Debug Adapter Protocol for Neovim
  ------------------------------------
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")

      for _, language in ipairs({ "typescript", "javascript" }) do
        -- Configura el adaptador pwa-node (para Node.js solo, sin navegadores)
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }

        dap.configurations[language] = {
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
            name = "Port 9222",
            port = 9222,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Port 9229",
            port = 9229,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Port 9230",
            port = 9230,
            cwd = "${workspaceFolder}",
          },
          -- NOT sure why not work - the issue is that not stop on breakpoints
          -- Filer to pick process based on open debug ports
          -- Same list as in chrome dev tools, see `whitelisted_ports`
          -- chrome://inspect/#devices -> Configure
          -- {
          --   type = "pwa-node",
          --   request = "attach",
          --   name = "Select Node Process",
          --   processId = function()
          --     -- Build map of PID -> ports FIRST
          --     local ss_output = vim.fn.system("ss -ltnp 2>/dev/null")
          --     local pid_to_port = {}
          --
          --     for line in ss_output:gmatch("[^\r\n]+") do
          --       local port = line:match("127%.0%.0%.1:(%d+)") or line:match(":::(%d+)")
          --       local pid = line:match("pid=(%d+)")
          --
          --       if port and pid then
          --         pid_to_port[tonumber(pid)] = port
          --       end
          --     end
          --
          --     -- Call pick_process with the label function that uses the map
          --     local dap_utils = require("dap.utils")
          --     local whitelisted_ports = {
          --       ["9222"] = true,
          --       ["9229"] = true,
          --       ["9230"] = true,
          --       ["9231"] = true,
          --       ["9232"] = true,
          --       ["3000"] = true,
          --     }
          --
          --     return dap_utils.pick_process({
          --       filter = function(proc)
          --         local port = pid_to_port[proc.pid]
          --         return port ~= nil and whitelisted_ports[port] == true
          --       end,
          --       -- label = function(proc)
          --       --   local port = pid_to_port[proc.pid] or "-"
          --       --   return string.format("%s - Proceso de %s", port, proc.name)
          --       -- end,
          --     })
          --   end,
          --   cwd = "${workspaceFolder}",
          --   sourceMaps = true,
          -- },
        }
      end

      -- Breakpoint signs with Nerd Font icons
      vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>dx", dap.terminate)

      vim.keymap.set("n", "<F6>", dap.step_into)
      vim.keymap.set("n", "<F7>", dap.step_over)
      vim.keymap.set("n", "<F8>", dap.step_out)
      vim.keymap.set("n", "<F9>", dap.step_back)
      vim.keymap.set("n", "<F10>", dap.restart)
    end,
  },

  -- seems not working
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-dap-virtual-text").setup()
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

      dapui.setup({
        controls = {
          element = "repl",
          enabled = true,
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
    end,
  },
}
