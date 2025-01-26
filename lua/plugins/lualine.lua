local ui = require("common.ui")
local utils = require("common.utils")
local icons = ui.icons
local colors = ui.colors

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  dependencies = "arkav/lualine-lsp-progress",
  opts = {
    options = {
      theme = "catppuccin",
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    extensions = { "neo-tree", "lazy", "toggleterm", "mason", "nvim-dap-ui", "quickfix" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch" },
        {
          "diff",
          symbols = icons.git,
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
      lualine_c = {
        { "filetype", padding = { left = 1, right = 0 }, separator = " ", icon_only = true },
        { "filename", padding = { left = 0, right = 1 } },
        { "diagnostics", symbols = icons.diagnostics },
        {
          "lsp_progress",
          display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
          colors = {
            percentage = colors.cyan,
            title = colors.cyan,
            message = colors.cyan,
            spinner = colors.cyan,
            lsp_client_name = colors.magenta,
            use = true,
          },
          separators = {
            component = " ",
            progress = " | ",
            percentage = { pre = "", post = "%% " },
            title = { pre = "", post = ": " },
            lsp_client_name = { pre = "[", post = "]" },
            spinner = { pre = "", post = "" },
            message = { commenced = "In Progress", completed = "Completed" },
          },
          timer = { progress_enddelay = 1000, spinner = 100, lsp_client_name_enddelay = 3000 },
          spinner_symbols = ui.spinner
        },
      },

      lualine_x = {
        { utils.macro_recording, color = { fg = "#ff9e64" }, separator = " " },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
        },
      },
      lualine_y = {
        { "searchcount", separator = " ", padding = { left = 1, right = 0 } },
        { "selectioncount", separator = " ", padding = { left = 1, right = 0 } },
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = { "encoding", "filesize", "fileformat" },
    },
  },
}
