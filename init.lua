vim.opt.runtimepath:prepend("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
local vimrc_path = vim.fn.expand("~/.vimrc")
if vim.loop.fs_stat(vimrc_path) then
  vim.cmd("source " .. vimrc_path)
end
require("config")
