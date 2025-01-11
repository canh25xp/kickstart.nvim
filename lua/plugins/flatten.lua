return {
  "willothy/flatten.nvim",
  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
  opts = {
    window = {
      open = "current",
      diff = "tab_vsplit",
      focus = "first",
    },
  },
}
