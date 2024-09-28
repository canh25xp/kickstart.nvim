local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local sep = vim.g.path_sep
local utils = require("common.utils")
local icons = require("common.ui").icons

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
    },
    event = { "BufRead", "BufNewFile" },
    opts = {
      inlay_hints = {
        enabled = false,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
    },
    config = function(_, opts)
      local tools_bin = vim.fn.stdpath("data") .. "/tools"
      local luals_bin = tools_bin .. "/lua-language-server/bin"
      local clangd_bin = tools_bin .. "/clangd/bin"
      local powershell_es_bundle = tools_bin .. "/powershell-editor-services"
      vim.env.PATH = vim.env.PATH .. sep .. luals_bin
      vim.env.PATH = vim.env.PATH .. sep .. clangd_bin .. sep

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

        if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(opts.inlay_hints.enabled)

          map("n", "<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
          end, "Inlay Hints Toggle")
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

        -- require("clangd_extensions.inlay_hints").setup_autocmd()
        -- require("clangd_extensions.inlay_hints").set_inlay_hints()
        -- local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })
        --
        -- vim.keymap.set("n", "<leader>uh", function()
        --   if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
        --     vim.api.nvim_create_autocmd("InsertEnter", { group = group, buffer = bufnr, callback = require("clangd_extensions.inlay_hints").disable_inlay_hints })
        --     vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        --       group = group,
        --       buffer = bufnr,
        --       callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
        --     })
        --   else
        --     vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        --   end
        -- end, { buffer = bufnr, desc = "Code Inlay Hints toggle" })
      end

      local capabilities = lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")
      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if status_ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      else
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        }
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
      end

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
          on_new_config = function(new_config, new_cwd)
            local status, cmake = pcall(require, "cmake-tools")
            if status then
              cmake.clangd_on_new_config(new_config)
            end
          end,
        })
      end

      if utils.executable("neocmakelsp") then
        lspconfig.neocmake.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
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
        lspconfig.powershell_es.setup({
          on_attach = lsp_attach,
          capabilities = capabilities,
          bundle_path = powershell_es_bundle,
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

      diagnostic.config({
        signs = {
          text = {
            [diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
        virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          prefix = "",
          header = "",
        },
      })

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
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          toggle_help = "?",
        },
      },
    },
  },
}
