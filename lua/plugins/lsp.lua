local utils = require("common.utils")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
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
          map({ "n", "x" }, "<leader>cF", function() vim.lsp.buf.format({ async = true }) end, "Format")
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
              runtime = {
                version = "LuaJIT",
              },
            },
          },
          capabilities = capabilities,
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
}
