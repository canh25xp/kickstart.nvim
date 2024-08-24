local function signcolumn_single_sign()
  local ns = vim.api.nvim_create_namespace("severe-diagnostics")
  local orig_signs_handler = vim.diagnostic.handlers.signs

  local function filter_diagnostics(diagnostics)
    if not diagnostics then
      return {}
    end

    -- Find the "worst" diagnostic per line
    local most_severe = {}
    for _, cur in pairs(diagnostics) do
      local max = most_severe[cur.lnum]

      -- higher severity has lower value (`:h diagnostic-severity`)
      if not max or cur.severity < max.severity then
        most_severe[cur.lnum] = cur
      end
    end

    return vim.tbl_values(most_severe) -- return list of diagnostics
  end

  vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, _, opts)
      -- Get all diagnostics from the whole buffer rather than just the diagnostics passed to the handler
      local diagnostics = vim.diagnostic.get(bufnr)

      local filtered_diagnostics = filter_diagnostics(diagnostics)

      -- Pass the filtered diagnostics (with the custom namespace) to the original handler
      orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,

    hide = function(_, bufnr)
      orig_signs_handler.hide(ns, bufnr)
    end,
  }
end
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- NOTE: Must be loaded before dependants
      "jay-babu/mason-nvim-dap.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp", -- For auto completion
      -- "j-hui/fidget.nvim", -- For LSP progress messages
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        desc = "LSP actions",
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local map = function(modes, keys, func, desc)
            vim.keymap.set(modes, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gY", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("n", "gr", vim.lsp.buf.references, "Goto References")
          map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map({ "n", "x" }, "<leader>cF", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")

          -- map("n", "gd", require("telescope.builtin").lsp_definitions, "Goto Definitions")
          -- map("n", "gr", require("telescope.builtin").lsp_references, "Goto References")
          -- map("n", "gI", require("telescope.builtin").lsp_implementations, "Goto Implementations")
          -- map("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definitions")
          -- map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          -- map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

            -- Highlight references of the word under cursor.
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights when cursor moves (the second autocommand).
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        clangd = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      require("mason").setup()

      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "python",
          "cppdbg",
        },
      })

      -- You can add other tools here that you want Mason to install for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "markdownlint",
        "shfmt",
        "deno",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
    signcolumn_single_sign(),
  },
  {
    "williamboman/mason.nvim",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "none",
        width = 0.9,
        height = 0.9,
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
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { plugins = { "nvim-dap-ui" }, types = true },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
}