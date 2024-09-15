require("config.options")
require("config.keymaps")
require("config.autocmds")
if vim.g.load_lazy_plugins then
  require("config.lazy")
end

if vim.g.vscode then
  require("config.vscode")
end

local tools_bin_dir = vim.fn.stdpath("data") .. "/tools"
local lua_language_server_bin_dir = tools_bin_dir .. "/lua-language-server/bin"

vim.env.PATH = vim.env.PATH .. vim.g.path_sep .. lua_language_server_bin_dir
