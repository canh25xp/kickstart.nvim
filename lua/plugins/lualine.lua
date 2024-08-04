-- stylua: ignore
local colors = {
  blue   = '#89b4fa',
  cyan   = '#94e2d5',
  black  = '#45475a',
  white  = '#eff1f5',
  red    = '#f38ba8',
  violet = '#cba6f7',
  grey   = '#303446',
}

local catppuccin = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = {
    a = { fg = colors.black, bg = colors.blue },
  },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = catppuccin,
      globalstatus = vim.o.laststatus == 3,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { "filename", "diagnostics" },

      lualine_x = { "hostname" },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        { "encoding" },
        { "filesize" },
        { "filetype" },
        { "fileformat" },
      },
    },
    extensions = { "neo-tree", "lazy", "toggleterm" },
  },
}
