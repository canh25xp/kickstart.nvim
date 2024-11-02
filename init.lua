vim.opt.runtimepath:prepend("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
if (vim.uv or vim.loop).fs_stat("~/.vimrc") then
  vim.cmd("source ~/.vimrc")
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
if vim.g.load_lazy_plugins then
  require("config.lazy")
end

if vim.g.vscode then
  require("config.vscode")
end
