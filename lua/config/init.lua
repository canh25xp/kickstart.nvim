require("config.options")
require("config.keymaps")
require("config.autocmds")
if not vim.g.minimal_config then
  require("config.lazy")
end
