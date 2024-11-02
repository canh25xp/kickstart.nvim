vim.opt.runtimepath:prepend("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()

if vim.loop.fs_stat("~/.vimrc") then
  vim.cmd("source ~/.vimrc")
end
require("config")
