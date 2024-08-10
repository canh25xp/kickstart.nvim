local utils = require("common.utils")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "jk", "<esc>", { desc = "Escape insert mode" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map({ "i", "x", "n", "s" }, "<C-S>", "<cmd>wa<cr><esc>", { desc = "Save All" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader><cr>", utils.ReloadConfig, { desc = "Reload Config" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg (man page)" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-u>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-u>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("n", "<A-d>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("i", "<A-d>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("v", "<A-d>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

-- Srolling
map("n", "<left>", "zh", { desc = "Scroll left" })
map("n", "<right>", "zl", { desc = "Scroll right" })
map("n", "<up>", "<C-y>", { desc = "Scroll up" })
map("n", "<down>", "<C-e>", { desc = "Scroll down" })

-- Move focus
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resizing
map("n", "<C-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })

-- buffers
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bp | bd #<cr>", { desc = "Delete Current Buffer" })

-- Terminal Mappings
map("t", "<C-_>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", utils.DiagnosticGoto(true), { desc = "Next Diagnostic" })
map("n", "[d", utils.DiagnosticGoto(false), { desc = "Prev Diagnostic" })
map("n", "]e", utils.DiagnosticGoto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", utils.DiagnosticGoto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", utils.DiagnosticGoto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", utils.DiagnosticGoto(false, "WARN"), { desc = "Prev Warning" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>c", "<cmd>tabnew<cr>", { desc = "Create Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- lazy
map("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })

-- Toggle
map("n", "<leader>uc", utils.Toggle_Theme, { desc = "Toggle Colorscheme" })
map("n", "<leader>ts", utils.Toggle_Signcolumn, { desc = "Toggle Sign Column" })

if vim.g.vscode then
  -- Load nvim vscode specific key bindings
  local vscode = require("vscode")
  map("n", "<leader>cf", function()
    vscode.action("editor.action.formatDocument")
  end)

  map("n", "<leader>gg", function()
    vscode.action("workbench.view.scm")
  end)

  map("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)

  map("n", "<leader>E", function()
    vscode.action("workbench.files.action.showActiveFileInExplorer")
  end)

  map("n", "<leader>j", function()
    vscode.action("workbench.action.togglePanel")
  end)
end
