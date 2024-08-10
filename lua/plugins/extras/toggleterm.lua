return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 20,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = true,
  },
  cmd = "ToggleTerm",
  keys = {
    { [[<C-\>]] },
    { "<leader>2", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    { "<leader>tt", "<Cmd>ToggleTerm direction=tab<Cr>", desc = "ToggleTerm in new tab" },
    {
      "<leader>gg",
      function()
        local term = require("toggleterm.terminal").Terminal
        local lazygit = term:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "tab",
        })
        lazygit:toggle()
      end,
      desc = "Lazygit",
    },
  },
}
