return {
  -- Automatically install LSPs to stdpath for neovim
  ---------------------------------------------------
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },

  -- Handle native neovim LSP
  ---------------------------
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local builtin = require("telescope.builtin")

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(event)
        -- Keymaps here will work only after LSP connects
        -- sets the mode, buffer and description for each keymap
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
        nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
        nmap("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("ga", vim.lsp.buf.code_action, "[G]oto [A]ction")

        nmap("[e", vim.diagnostic.goto_prev)
        nmap("]e", vim.diagnostic.goto_next)

        nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
        nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- See `:help K` for why this keymap
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Lesser used LSP functionality
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = on_attach,
      })

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_create_user_command("Format", vim.lsp.buf.format, { desc = "Format current buffer with LSP" })

      vim.keymap.set("n", "<leader>,", vim.lsp.buf.format)

      -- Setup mason so it can manage external tooling
      require("mason").setup()

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "rust_analyzer",
          "pyright",
          "ts_ls",
          "lua_ls",
          "phpactor",
          "tailwindcss",
          "cssls",
          "cssmodules_ls",
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({
              -- on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  workspace = {
                    checkThirdParty = false,
                  },
                },
              },
            })
          end,

          ["ts_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
              on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
              end,
            })
          end,

          ["pyright"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.pyright.setup({
              capabilities = capabilities, -- use your own capabilities if you have them set elsewhere
              on_new_config = function(new_config, root_dir)
                local util = require("lspconfig.util")
                local venv_paths = { ".venv", "venv" }
                for _, venv in ipairs(venv_paths) do
                  local python_bin = util.path.join(root_dir, venv, "bin", "python")
                  if vim.fn.executable(python_bin) == 1 then
                    new_config.settings = new_config.settings or {}
                    new_config.settings.python = new_config.settings.python or {}
                    new_config.settings.python.pythonPath = python_bin
                    return
                  end
                end
                -- fallback to system python
                new_config.settings = new_config.settings or {}
                new_config.settings.python = new_config.settings.python or {}
                new_config.settings.python.pythonPath = vim.fn.exepath("python3") or "python3"
              end,
            })
          end,
        },
      })
    end,
  },

  -- CMP
  ------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s", "c" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "buffer", group_index = 2 },
        }),
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = {
          { name = "cmp_git" },
          { name = "buffer" },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ["<down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "c" }),
          ["<up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
        }),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        completion = {
          autocomplete = {
            cmp.TriggerEvent.TextChanged,
            cmp.TriggerEvent.InsertEnter,
          },
          completeopt = "menuone,noinsert,noselect",
          keyword_length = 0,
        },
        mapping = cmp.mapping.preset.cmdline({
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "c" }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "c" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
