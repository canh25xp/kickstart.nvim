--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true

require("config/options")

require("config/keymaps")

require("config/autocmds")

require("config/lazy")

vim.cmd.colorscheme("catppuccin-mocha")

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
