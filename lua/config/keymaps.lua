local utils = require("common.utils")

local map = vim.keymap.set

-- General
map("i", "jk", "<esc>", { desc = "Escape insert mode" })
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>QQ", "<cmd>wqa<cr>", { desc = "Write Quit All" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg (man page)" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map({ "i", "x", "n", "s" }, "<C-S>", "<cmd>wa<cr><esc>", { desc = "Save All" })

map("n", "J", "mzJ`z", { desc = "Join without moving cursor" })
map("n", "<leader>/", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Change word under cursor" })

-- Yank and Paste
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboad" })
map("n", "<leader>P", [["+P]], { desc = "Paste form system clipboard" })
map("n", "<leader>p", [["+p]], { desc = "Paste form system clipboard" })
map("n", "<leader>ay", 'gg"+yG', { desc = "Yank whole file" })
map("i", "<C-r><C-r>", [[<C-o>"+p]], { desc = "Paste form system clipboard" })

-- Delete
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Netrw
map("n", "<leader>e", ":Lexplore<CR>", { desc = "Netrw Explorer (root)" })
map("n", "<leader>E", ":Lexplore %:p:h<CR>", { desc = "Netrw Explorer (cwd)" })

-- Lazy
map("n", "<leader>ll", utils.Load_Lazy, { desc = "Load Lazy Plugins" })
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Sessions
map("n", "<leader>qr", ":source Session.vim<cr>", { desc = "Restore Session" })
map("n", "<leader>qs", ":mksession!<cr>", { desc = "Save Session" })

-- UI
map("n", "<leader>us", utils.Toggle_Signcolumn, { desc = "Toggle Signcolumn" })
map("n", "<leader>ur", utils.ReloadConfig, { desc = "Reload Config" })
map("n", "<leader>uR", ":nohlsearch|diffupdate|normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- Diagnostic
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", utils.DiagnosticGoto(true), { desc = "Next Diagnostic" })
map("n", "[d", utils.DiagnosticGoto(false), { desc = "Prev Diagnostic" })
map("n", "]e", utils.DiagnosticGoto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", utils.DiagnosticGoto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", utils.DiagnosticGoto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", utils.DiagnosticGoto(false, "WARN"), { desc = "Prev Warning" })

-- Better scroll
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- Saner behavior of n and N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Move Lines
map("n", "<A-u>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-u>", ":m '<-2<cr>gv=gv", { desc = "Move Line Up" })
map("n", "<A-d>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("i", "<A-d>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("v", "<A-d>", ":m '>+1<cr>gv=gv", { desc = "Move Line Down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" })

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
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bp | bd #<cr>", { desc = "Delete Current Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Terminal Mappings
map("n", "<leader>tt", utils.TabTerminal, { desc = "New Tab Terminal" })
map("n", "<leader>gg", utils.LazyGit, { desc = "Lazygit" })
map("n", "<leader>gl", utils.LazyGit_Log, { desc = "Lazygit Log" })
map("n", "<C-\\>", "<cmd>split|terminal<CR>", { desc = "New Terminal" })
map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "jk", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
map("t", "<C-_>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Focus Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Focus Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Focus Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Focus Right Window" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Create New Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

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
