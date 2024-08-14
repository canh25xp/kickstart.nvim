return {
  "j-hui/fidget.nvim",
  lazy = true,
  opts = {
    notification = {
      window = {
        winblend = 50, -- Background color opacity in the notification window
        border = "none", -- Border around the notification window
        zindex = 45, -- Stacking priority of the notification window
        max_width = 0, -- Maximum width of the notification window
        max_height = 0, -- Maximum height of the notification window
        x_padding = 0, -- Padding from right edge of window boundary
        y_padding = 0, -- Padding from bottom edge of window boundary
        align = "bottom", -- How to align the notification window
        relative = "editor", -- What the notification window position is relative to
      },
    },
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
