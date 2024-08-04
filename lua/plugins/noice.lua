return {
  "folke/noice.nvim",
  enabal = false,
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },
    },
    cmdline = {
      view = "cmdline",
    },
    presets = {
      command_palette = false,
      lsp_doc_border = true,
      bottom_search = true,
      long_message_to_split = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    -- "MunifTanjim/nui.nvim",
    -- `nvim-notify` is only needed, if you want to use the notification view. If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
}
