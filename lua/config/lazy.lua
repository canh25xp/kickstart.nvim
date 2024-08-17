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
vim.opt.rtp:prepend(lazypath)

local opts = {
  spec = {
    -- Lazyvim distro
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import all plugins
    { import = "plugins" },
    -- Import single plugin
    -- { import = "plugins.catppuccin" },
    -- { import = "plugins.neo-tree" },
    -- { import = "plugins.nvim-treesitter" },
    -- { import = "plugins.lspconfig" },
    -- { import = "plugins.nvim-cmp" },
    -- { import = "plugins.conform" },
    -- { import = "plugins.toggleterm" },
    -- { import = "plugins.persistance" },
    -- { import = "plugins.which-key" },
    -- { import = "plugins.nvim-lint" },
    -- { import = "plugins.zenmode" },
    -- { import = "plugins.mini" },
    -- { import = "plugins.lualine" },
    -- { import = "plugins.noice" },
    -- { import = "plugins.gitsigns" },
    -- { import = "plugins.url-open" },
    -- { import = "plugins.nvim-dap" },
    -- { import = "plugins.peek" },
    -- { import = "plugins.autopairs" },
  },
  checker = { enabled = false }, -- Don't automatically check for plugin updates

  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },

  install = { colorscheme = { "catppuccin-mocha" } },

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
    size = {
      width = 0.9,
      height = 0.9,
    },
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
}

require("lazy").setup(opts)
