require("config.options")
require("config.keymaps")
require("config.autocmds")
if vim.g.load_lazy_plugins then
  require("config.lazy")
end

if vim.g.vscode then
  require("config.vscode")
end

local sep = vim.g.path_sep

local tools_bin = vim.fn.stdpath("data") .. "/tools"
local luals_bin = tools_bin .. "/lua-language-server/bin"
local clangd_bin = tools_bin .. "/clangd/bin"

vim.env.PATH = vim.env.PATH .. sep .. luals_bin
vim.env.PATH = vim.env.PATH .. sep .. clangd_bin .. sep
