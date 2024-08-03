-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", ":Neotree reveal<CR>", desc = "NeoTree Reveal" },
    {
      "<c-n>",
      function()
        require("neo-tree.command").execute({ toggle = true })
      end,
      desc = "NeoTree Toggle",
    },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_pattern = {
            "**/*.log",
            "**/__pycache__",
          },
        },
      },
      window = {
        mappings = {
          ["<leader>e"] = "close_window",
          ["l"] = "open",
          ["h"] = "close_node",
          ["."] = "toggle_hidden",
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = false } },
        },
      },
    },
  },
}
