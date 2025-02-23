return {
  "williamboman/mason.nvim",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
    ui = {
      check_outdated_packages_on_open = false,
      border = "rounded",
      width = 0.9,
      height = 0.8,
      icons = require("common.ui").icons.mason,
      keymaps = {
        toggle_help = "?",
        uninstall_package = "x",
      },
    },
  },
}
