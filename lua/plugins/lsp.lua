local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local utils = require("common.utils")
local icons = require("common.ui").icons

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- NOTE: Must be loaded before dependants
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim", -- For LSP progress messages
    },
    event = { "BufRead", "BufNewFile" },
    config = function()
      local function lsp_attach(client, bufnr)
        local function map(modes, keys, func, desc)
          vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("n", "K", lsp.buf.hover, "Hover")
        map("n", "gd", lsp.buf.definition, "Goto Definition")
        map("n", "gD", lsp.buf.declaration, "Goto Declaration")
        map("n", "gI", lsp.buf.implementation, "Goto Implementation")
        map("n", "gY", lsp.buf.type_definition, "Goto Type Definition")
        map("n", "gr", lsp.buf.references, "Goto References")
        map("n", "gs", lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", lsp.buf.signature_help, "Signature help")
        map("n", "<leader>cr", lsp.buf.rename, "Rename")
        map("n", "<leader>ca", lsp.buf.code_action, "Code Action")

        if client.server_capabilities.documentFormattingProvider then
          map({ "n", "x" }, "<leader>cF", function()
            lsp.buf.format({ async = true })
          end, "Format")
        end

        -- Highlight the current variable and its usages in the buffer.
        if client.server_capabilities.documentHighlightProvider then
          api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
          api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
          api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
          local gid = api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

          -- highlight references of the word under cursor.
          api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = gid,
            callback = lsp.buf.document_highlight,
          })

          -- clear highlights when cursor moves.
          api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = gid,
            callback = lsp.buf.clear_references,
          })

          api.nvim_create_autocmd("lspdetach", {
            group = api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              lsp.buf.clear_references()
              api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
        local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })

        vim.keymap.set("n", "<leader>uh", function()
          if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
            vim.api.nvim_create_autocmd("InsertEnter", { group = group, buffer = bufnr, callback = require("clangd_extensions.inlay_hints").disable_inlay_hints })
            vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
              group = group,
              buffer = bufnr,
              callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
            })
          else
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
          end
        end, { buffer = bufnr, desc = "Code Inlay Hints toggle" })
      end

      local capabilities = lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      if utils.executable("vscode-json-language-server") then
        require("lspconfig").jsonls.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        })
      end

      if utils.executable("lua-language-server") then
        lspconfig.lua_ls.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
              runtime = {
                version = "LuaJIT",
              },
            },
          },
        })
      end

      if utils.executable("clangd") then
        lspconfig.clangd.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          filetypes = { "c", "cpp", "cc" },
          flags = {
            debounce_text_changes = 500,
          },
          cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
          init_options = {
            fallback_flags = { "-std=c++17" },
          },
        })
      end

      if utils.executable("pyright") then
        lspconfig.pyright.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
        })
      elseif utils.executable("pylsp") then
        local venv_path = os.getenv("VIRTUAL_ENV")
        local py_path = nil
        -- decide which python executable to use for mypy
        if venv_path ~= nil then
          py_path = venv_path .. "/bin/python3"
        else
          py_path = vim.g.python3_host_prog
        end

        lspconfig.pylsp.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          settings = {
            pylsp = {
              plugins = {
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                ruff = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = {
                  enabled = true,
                  overrides = { "--python-executable", py_path, true },
                  report_progress = true,
                  live_mode = false,
                },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                isort = { enabled = true },
              },
            },
          },
          flags = {
            debounce_text_changes = 200,
          },
        })
      end

      if utils.executable("ltex-ls") then
        lspconfig.ltex.setup({
          on_attach = lsp_attach,
          cmd = { "ltex-ls" },
          filetypes = { "text", "plaintex", "tex", "markdown" },
          settings = {
            ltex = {
              language = "en",
            },
          },
          flags = { debounce_text_changes = 300 },
        })
      end

      if utils.executable("bash-language-server") then
        lspconfig.bashls.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
        })
      end

      if vim.g.is_windows then
        local tools_bin = vim.fn.stdpath("data") .. "/tools"
        local bundle_path = tools_bin .. "/powershell_es"
        lspconfig.powershell_es.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          bundle_path = bundle_path,
        })
      end

      if utils.executable("vim-language-server") then
        lspconfig.vimls.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 500,
          },
        })
      end

      utils.set_lsp_border("rounded")
      utils.signcolumn_single_sign()
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "b0o/schemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
    -- config = function()
    --   require("schemastore").json.schemas({
    --     extra = {
    --       {
    --         description = "Local Terminal settings json schema",
    --         fileMatch = "settings.json",
    --         name = "settings.json",
    --         url = "file:///C:/Users/Michael/.local/share/chezmoi/.schema/terminal.json", -- or '/path/to/your/schema.json'
    --       },
    --     },
    --   })
    -- end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = icons.ast,
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("clangd_extensions").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    lazy = true,
    opts = {
      notification = {
        window = {
          winblend = 0, -- Background color opacity in the notification window
          border = "none", -- Border around the notification window
          zindex = 45, -- Stacking priority of the notification window
          max_width = 0, -- Maximum width of the notification window
          max_height = 0, -- Maximum height of the notification window
          x_padding = 0, -- Padding from right edge of window boundary
          y_padding = 0, -- Padding from bottom edge of window boundary
          align = "bottom", -- How to align the notification window
          relative = "editor", -- What the notification window position is relative to
        },
      },
      progress = {
        display = {
          render_limit = 16, -- How many LSP messages to show at once
          done_ttl = 5, -- How long a message should persist after completion
          done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
          done_style = "Constant", -- Highlight group for completed LSP tasks
          progress_ttl = math.huge, -- How long a message should persist when in progress
          progress_icon = { pattern = "dots", period = 1 }, -- Icon shown when LSP progress tasks are in progress
          progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
          group_style = "Title", -- Highlight group for group name (LSP server name)
          icon_style = "Question", -- Highlight group for group icons
          priority = 30, -- Ordering priority for LSP notification group
          skip_history = false, -- Whether progress notifications should be omitted from history
          overrides = { -- Override options from the default notification config
            rust_analyzer = { name = "rust-analyzer" },
          },
        },
      },
    },
  },
}
