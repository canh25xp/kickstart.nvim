local ui = require("common.ui")
local recording_macro = require("common.utils").macro_recording
local icons = ui.icons
local git = {
  added = icons.git.added,
  modified = icons.git.modified,
  removed = icons.git.removed,
}

local diagnostics = {
  error = icons.diagnostics.Error,
  warn = icons.diagnostics.Warn,
  info = icons.diagnostics.Info,
  hint = icons.diagnostics.Hint,
}

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
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
          symbols = git,
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
        { "diagnostics", symbols = diagnostics },
      },

      lualine_x = {
        { recording_macro, color = { fg = "#ff9e64" }, separator = " " },
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
