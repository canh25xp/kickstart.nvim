require("config.options")
require("config.keymaps")
require("config.autocmds")
if vim.g.load_lazy_plugins then
  require("config.lazy")
end
