local utils = require("common.utils")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim", -- For LSP progress messages
    },
    event = { "BufRead", "BufNewFile" },
    config = function()
      local function lsp_attach(client, bufnr)
        local function map(modes, keys, func, desc)
          vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
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
        if client.server_capabilities.documentFormattingProvider then
          map({ "n", "x" }, "<leader>cF", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      if utils.executable("lua-language-server") then
        -- https://github.com/LuaLS/lua-language-server/wiki/Settings .
        lspconfig.lua_ls.setup({
          on_attach = lsp_attach,
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
          capabilities = capabilities,
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
