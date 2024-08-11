--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.termguicolors = true -- True color support
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.pumwidth = 15 -- Minimum width for the popup menu
-- vim.opt.shortmess:append({ W = true, c = true, C = true })
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.confirm = true -- Ask to save changes before exiting modified buffer
vim.opt.laststatus = 3 -- global statusline
vim.opt.mousemoveevent = true
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- vim.opt.statuscolumn = [[%!v:lua.require('common.ui').statuscolumn()]]
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.breakindent = true
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = vim.g.vscode and 1000 or 500 -- Lower than default (1000) to quickly trigger which-key
vim.opt.inccommand = "split" -- Preview substitutions live, as you type
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- Use a bold seperators
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

vim.cmd.colorscheme("sorbet")

if vim.g.neovide then
  -- vim.o.guifont = "CaskaydiaCove Nerd Font:h12"
  vim.g.neovide_fullscreen = false
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_transparency = 1.0
end

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
