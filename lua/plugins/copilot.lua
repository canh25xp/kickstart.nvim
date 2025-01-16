return {
  "github/copilot.vim",
  enable = true,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
    vim.g.copilot_no_tab_map = true
  end,
}
