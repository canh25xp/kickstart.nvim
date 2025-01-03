local icons = require("common.ui")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.runtimepath:prepend(lazypath)

local opts = {
  spec = {
    { import = "plugins.autopairs" },
    { import = "plugins.bufferline" },
    { import = "plugins.catppuccin" },
    { import = "plugins.cmake-tools" },
    { import = "plugins.cmp" },
    { import = "plugins.conform" },
    { import = "plugins.dap" },
    { import = "plugins.fzf" },
    { import = "plugins.gitsigns" },
    { import = "plugins.lsp" },
    { import = "plugins.lualine" },
    { import = "plugins.mini" },
    { import = "plugins.neo-tree" },
    { import = "plugins.persistance" },
    { import = "plugins.telescope" },
    { import = "plugins.toggleterm" },
    { import = "plugins.treesitter" },
    { import = "plugins.vim-sleuth" },
    { import = "plugins.vimtex" },
    { import = "plugins.luaSnip" },
    { import = "plugins.chezmoi" },
  },
  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
  dev = {
    path = "~/projects/lua",
  },
  checker = { enabled = false }, -- Don't automatically check for plugin updates
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- get a notification when changes are found
  },
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    size = { width = 0.9, height = 0.8 },
    icons = vim.g.have_nerd_font and {} or icons.lazy,
  },
  rocks = {
    enabled = false,
  },
}

if vim.g.is_linux then
  table.insert(opts.spec, { import = "plugins.dashboard" })
  table.insert(opts.spec, { import = "plugins.lint" })
  table.insert(opts.spec, { import = "plugins.noice" })
  table.insert(opts.spec, { import = "plugins.todo-comments" })
  table.insert(opts.spec, { import = "plugins.url-open" })
  table.insert(opts.spec, { import = "plugins.which-key" })
  table.insert(opts.spec, { import = "plugins.peek" })
end

require("lazy").setup(opts)
