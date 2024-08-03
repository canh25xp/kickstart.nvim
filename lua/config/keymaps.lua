vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights on search" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- NOTE: This won't work in all terminal emulators/tmux/etc.
-- Try your own mapping or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- vim.keymap.set('n', '<left>', '<zh>')
-- vim.keymap.set('n', '<right>', '<zl>')
vim.keymap.set("n", "<up>", "<C-y>")
vim.keymap.set("n", "<down>", "<C-e>")

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

if vim.g.vscode then
  -- Load nvim vscode specific key bindings
  local vscode = require("vscode")
  vim.keymap.set("n", "<leader>cf", function()
    vscode.action("editor.action.formatDocument")
  end)

  vim.keymap.set("n", "<leader>gg", function()
    vscode.action("workbench.view.scm")
  end)

  vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)

  vim.keymap.set("n", "<leader>E", function()
    vscode.action("workbench.files.action.showActiveFileInExplorer")
  end)

  vim.keymap.set("n", "<leader>j", function()
    vscode.action("workbench.action.togglePanel")
  end)
end
