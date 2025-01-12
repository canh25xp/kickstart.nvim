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
  config = function(_, opts)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm*", -- "term://*" to apply for all terminal
      desc = "toggleterm keymap",
      callback = function()
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = 0 })
        -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0 })
        -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0 })
        -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0 })
        -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0 })
        -- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
      end,
    })
    require("toggleterm").setup(opts)
  end,
  cmd = "ToggleTerm",
  keys = {
    { "<C-\\>" },
    { "<leader>t1", "<Cmd>1ToggleTerm<Cr>", desc = "Terminal #1" },
    { "<leader>t2", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    { "<leader>tt", "<Cmd>ToggleTerm direction=tab<Cr>", desc = "ToggleTerm in new tab" },
    -- {
    --   "<leader>gg",
    --   function()
    --     local lazygit = require("toggleterm.terminal").Terminal:new({
    --       cmd = "lazygit",
    --       dir = "git_dir",
    --       direction = "tab",
    --     })
    --     lazygit:toggle()
    --   end,
    --   desc = "Lazygit",
    -- },
    -- {
    --   "<leader>gl",
    --   function()
    --     local lazygit = require("toggleterm.terminal").Terminal:new({
    --       cmd = "lazygit log",
    --       dir = "git_dir",
    --       direction = "tab",
    --     })
    --     lazygit:toggle()
    --   end,
    --   desc = "Lazygit log",
    -- },
  },
}
