return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = true,
    float_opts = {
      title_pos = "center",
      border = "curved",
    },
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
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      hidden = true,
      direction = "tab",
      on_create = function(term)
        local bn = term.bufnr
        vim.api.nvim_buf_set_keymap(bn, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true }) -- NOTE: hide terminal instead of quit lazygit
        vim.api.nvim_buf_del_keymap(bn, "t", "jk")
        vim.api.nvim_buf_set_keymap(bn, "t", "<esc>", "<esc>", { noremap = true, silent = true, nowait = true })
      end,
      on_open = function(_)
        vim.cmd("startinsert!") -- NOTE:This is a little redundant, maybe remove it
      end,
      on_close = function(_)
        vim.cmd("startinsert!")
      end,
    })
    local lazygit_log = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit log",
      dir = "git_dir",
      hidden = true,
      direction = "tab",
      display_name = "Lazygit Log",
      on_create = function(term)
        local bn = term.bufnr
        vim.api.nvim_buf_set_keymap(bn, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true }) -- NOTE: hide terminal instead of quit lazygit
        vim.api.nvim_buf_del_keymap(bn, "t", "jk")
        vim.api.nvim_buf_set_keymap(bn, "t", "<esc>", "<esc>", { noremap = true, silent = true, nowait = true })
      end,
      on_open = function(_)
        vim.cmd("startinsert!") -- NOTE:This is a little redundant, maybe remove it
      end,
      on_close = function(_)
        vim.cmd("startinsert!")
      end,
    })
    function _LazygitLogToggle()
      lazygit_log:toggle()
    end
    function _LazygitToggle()
      lazygit:toggle()
    end
  end,
  cmd = "ToggleTerm",
  keys = {
    { "<C-\\>" },
    { "<leader>t1", "<Cmd>1ToggleTerm<Cr>", desc = "Terminal #1" },
    { "<leader>t2", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    { "<leader>tt", "<Cmd>ToggleTerm direction=tab<Cr>", desc = "ToggleTerm in new tab" },
    { "<leader>gg", "<cmd>lua _LazygitToggle()<CR>", desc = "Lazygit" },
    { "<leader>gl", "<cmd>lua _LazygitLogToggle()<CR>", desc = "Lazygit Log" },
  },
}
