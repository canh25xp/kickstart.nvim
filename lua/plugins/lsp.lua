local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local utils = require("common.utils")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- For auto completion
    },
    event = { "BufRead", "BufNewFile" },
    config = function()
      local custom_attach = function(client, bufnr)
        local map = function(modes, keys, func, desc)
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

        api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local float_opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always", -- show source in diagnostic popup window
              prefix = " ",
            }

            if not vim.b.diagnostics_pos then
              vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and #diagnostic.get() > 0 then
              diagnostic.open_float(nil, float_opts)
            end

            vim.b.diagnostics_pos = cursor_pos
          end,
        })

        -- The blow command will highlight the current variable and its usages in the buffer.
        if client.server_capabilities.documentHighlightProvider then
          vim.cmd([[
            hi! link LspReferenceRead Visual
            hi! link LspReferenceText Visual
            hi! link LspReferenceWrite Visual
          ]])

          local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          api.nvim_create_autocmd("CursorHold", {
            group = gid,
            buffer = bufnr,
            callback = function()
              lsp.buf.document_highlight()
            end,
          })

          api.nvim_create_autocmd("CursorMoved", {
            group = gid,
            buffer = bufnr,
            callback = function()
              lsp.buf.clear_references()
            end,
          })
        end
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      if utils.executable("lua-language-server") then
        -- https://github.com/LuaLS/lua-language-server/wiki/Settings .
        lspconfig.lua_ls.setup({
          on_attach = custom_attach,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
            },
          },
          capabilities = capabilities,
        })
      end

      -- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
      lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, { border = "rounded", })
      utils.signcolumn_single_sign()
    end,
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
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
}
