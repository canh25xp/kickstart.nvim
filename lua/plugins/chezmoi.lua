return {
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
      require("nvim-treesitter.configs").setup({
        highlight = {
          disable = function()
            if string.find(vim.bo.filetype, "chezmoitmpl") then
              return true
            end
            -- TODO: Some how make this only when vimtex is enabled.
            if vim.bo.filetype == "tex" then
              return true
            end
          end,
        },
      })
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    keys = {
      {
        "<leader>sz",
        require("common.utils").pick_chezmoi,
        desc = "Chezmoi",
      },
    },
    opts = {
      edit = {
        watch = false,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
        on_watch = false,
      },
      telescope = {
        select = { "<CR>" },
      },
    },
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        -- TODO:: test this on both windows and linux
        -- pattern = { os.getenv("USERPROFILE") .. "/.local/share/chezmoi/*" },
        pattern = { "~/.local/share/chezmoi/*" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
}
