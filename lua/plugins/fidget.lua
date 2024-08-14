return {
  "j-hui/fidget.nvim",
  lazy = true,
  opts = {
    progress = {
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 5, -- How long a message should persist after completion
        done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
        done_style = "Constant", -- Highlight group for completed LSP tasks
        progress_ttl = math.huge, -- How long a message should persist when in progress
        progress_icon = { pattern = "dots", period = 1 }, -- Icon shown when LSP progress tasks are in progress
        progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
        group_style = "Title", -- Highlight group for group name (LSP server name)
        icon_style = "Question", -- Highlight group for group icons
        priority = 30, -- Ordering priority for LSP notification group
        skip_history = false, -- Whether progress notifications should be omitted from history
        overrides = { -- Override options from the default notification config
          rust_analyzer = { name = "rust-analyzer" },
        },
      },
    },
  },
}
