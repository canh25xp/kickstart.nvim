vim.opt.runtimepath:prepend("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd("source ~/.vimrc")
require("config")
