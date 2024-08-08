local utils = require("config/utils")

vim.keymap.set("i", "jk", "<esc>", { desc = "Escape insert mode" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-S>", "<cmd>wa<cr><esc>", { desc = "Save All" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader><cr>", utils.ReloadConfig, { desc = "Reload Config" })
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg (man page)" })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
vim.keymap.set("n", "<A-u>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-u>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set("n", "<A-d>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
vim.keymap.set("i", "<A-d>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("v", "<A-d>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

-- Srolling
vim.keymap.set("n", "<left>", "zh", { desc = "Scroll left" })
vim.keymap.set("n", "<right>", "zl", { desc = "Scroll right" })
vim.keymap.set("n", "<up>", "<C-y>", { desc = "Scroll up" })
vim.keymap.set("n", "<down>", "<C-e>", { desc = "Scroll down" })

-- Move focus
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })

-- buffers
vim.keymap.set("n", "H", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bp | bd #<cr>", { desc = "Delete Current Buffer" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", utils.DiagnosticGoto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", utils.DiagnosticGoto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", utils.DiagnosticGoto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", utils.DiagnosticGoto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", utils.DiagnosticGoto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", utils.DiagnosticGoto(false, "WARN"), { desc = "Prev Warning" })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

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
