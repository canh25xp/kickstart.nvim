--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local utils = require("common.utils")

-- General Settings
local general = augroup("General Settings", { clear = true })

if vim.g.is_windows then
  autocmd({ "CmdlineEnter", "RecordingEnter" }, {
    callback = function() vim.opt.cmdheight = 1 end,
    desc = "Change cmdheight when typing macro or command"
  })

  autocmd({ "CmdlineLeave", "RecordingLeave" }, {
    callback = function() vim.opt.cmdheight = 0 end,
    desc = "Change cmdheight when leaving macro or command"
  })
end

autocmd("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no" })
autocmd("TermClose", { command = "bdelete" })

-- autocmd({ "TermOpen", "WinEnter" }, { pattern = "term://*", command = "startinsert" })

autocmd("BufEnter", {
  pattern = "",
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.filetype == "" then
      map("n", "r", "<leader>qr", { desc = "Restore Session", buffer = 0, remap = true })
    end
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = general,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = general,
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("FileType", {
  group = general,
  pattern = {
    "help",
    "checkhealth",
    "netrw",
    "dap-float"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quick Quit buffer",
    })
  end,
})

