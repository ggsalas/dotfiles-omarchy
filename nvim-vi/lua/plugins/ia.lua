return {
  -- COPILOT
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false }, -- disable inline suggestions if you want to use cmp menu only
            panel = { enabled = false },
          })
        end,
      },
      "hrsh7th/nvim-cmp",
    },
  },

  -- COPILOT_CHAT
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          print("Copilot Chat opened!")
          -- Your custom logic here
          vim.schedule(function()
            vim.cmd("wincmd L")
            vim.cmd("vertical resize 80")
          end)
        end,
      })

      local chat = require("CopilotChat")
      chat.setup({
        window = {
          layout = 'vertical',
        },
        mappings = {
          reset = {
            normal = '<C-x>',
            insert = '<C-x>',
          },
          toggle = {
            normal = '<leader>cp',
            insert = '<leaoer>cp',
          },
        },
      })

      -- Keymap to toggle chat window
      vim.keymap.set("n", "<leader>i", chat.toggle, { desc = "Toggle Copilot Chat" })

      -- Related with current buffer or selection
      vim.keymap.set({ "n", "v" }, "<leader>ib", function()
        local mode = vim.fn.mode()
        local question = vim.fn.input("Ask Copilot (buffer/selection context): ")
        if question == "" then return end
        local opts = {}
        if mode == "v" or mode == "V" or mode == "\22" then
          opts.range = true
        else
          opts.context = "buffer"
        end
        require("CopilotChat").ask(question, opts)
      end, { desc = "Ask Copilot a question with buffer or selection context" })

      -- Questions related with current workspace
      vim.keymap.set("n", "<leader>cw", function()
        local question = vim.fn.input("Ask Copilot (workspace context): ")
        if question == "" then return end
        require("CopilotChat").ask(question, { context = "workspace" })
      end, { desc = "Ask Copilot a question with workspace context" })
    end,
  },

  -- OLLAMA_GEN
  {
    "David-Kunz/gen.nvim",

    config = function()
      -- vim.keymap.set({ 'n', 'v' }, '<leader>i', ':Gen<CR>')
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ii', ':Gen Code_File_Chat<CR>')
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ij', ':Gen Code_File_Chat<CR>')
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ig', ':Gen General_Chat<CR>')

      require('gen').setup({
        model = "llama3",       -- The default model to use. // codellama //
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = true,     -- Shows the Prompt submitted to Ollama.
        show_model = true,      -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true,   -- Never closes the window automatically.
        debug = false           -- Prints errors and the command which is run.
      })

      require('gen').prompts = {
        General_Chat = { prompt = "$input" },

        General_Execute = { prompt = "$input", replace = true },

        Code_Chat = {
          prompt = "You are an expert programmer that writes simple, concise code and explanations. $input"
        },

        Code_File_Chat = {
          prompt =
          "You are an expert programmer that writes simple, concise code and explanations. Use the propper language for the $filetype file. $input"
        },

        Code_Refactor = {
          prompt =
          "You are an expert programmer that writes simple, concise code. Regarding the following code, $input, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = true,
          extract = "```$filetype\n(.-)```",
        },

        Code_Explain = {
          prompt = "Read the following code and briefly bur concisely explain what is doing:\n```$filetype\n$text\n```",
        },

        Code_Review = {
          prompt = "Review the following code and make concise suggestions:\n```$filetype\n$text\n```",
        },

        Code_Enhance = {
          prompt =
          "Enhance the following code, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = true,
          extract = "```$filetype\n(.-)```",
        },

        Code_Fix = {
          prompt =
          "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = true,
          extract = "```$filetype\n(.-)```"
        },

        Code_Unit_test_case = {
          prompt =
          "You are an expert programmer that writes simple, concise code. Write unit test case for, $input, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = false,
          extract = "```$filetype\n(.-)```",
        },

        -- Txt inputs
        -------------
        Txt_Summarize = { prompt = "Summarize the following text:\n$text" },

        Txt_Ask = { prompt = "Regarding the following text, $input:\n$text" },

        Txt_Change = {
          prompt =
          "Change the following text, $input, just output the final text without additional quotes around it:\n$text",
          replace = true,
        },

        Txt_Enhance_Grammar_Spelling = {
          prompt =
          "Modify the following text to improve grammar and spelling, just output the final text without additional quotes around it:\n$text",
          replace = true,
        },

        Txt_Enhance_Wording = {
          prompt =
          "Modify the following text to use better wording and fix spelling errors if they exist, just output the final text without additional quotes around it:\n$text",
          replace = true,
        },

        Txt_Make_Concise = {
          prompt =
          "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n$text",
          replace = true,
        },

        Elaborate_Text = {
          prompt = "Elaborate the following text:\n$text",
          replace = true
        },

        Txt_Make_List = {
          prompt = "Render the following text as a markdown list:\n$text",
          replace = true,
        },

        Txt_Make_Table = {
          prompt = "Render the following text as a markdown table:\n$text",
          replace = true,
        },
      }
    end
  }
}
