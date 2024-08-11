--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("common.utils")

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no" })

autocmd({ "TermOpen", "WinEnter" }, { pattern = "term://*", command = "startinsert" })

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
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})
