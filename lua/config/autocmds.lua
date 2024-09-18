--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local utils = require("common.utils")

-- General Settings
local general = augroup("General Settings", { clear = true })

autocmd("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no" })

autocmd({ "TermOpen", "WinEnter" }, { pattern = "term://*", command = "startinsert" })

autocmd("TermClose", {
  callback = function()
    vim.cmd("bdelete")
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
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
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "qq", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quick Quit buffer",
    })
  end,
})

autocmd("FileType", {
  pattern = "netrw",
  desc = "Better mappings for Netrw",
  callback = function()
    map("n", "n", "%", { desc = "Netrw New file", remap = true, buffer = true })
    map("n", "r", "R", { desc = "Netrw Rename file", remap = true, buffer = true })
    map("n", "H", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
    map("n", ".", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
    -- map("n", "h", "-^", { desc = "Netrw go up", remap = true, buffer = true })
    map("n", "l", "l<cr>", { desc = "Netrw open file", remap = true, buffer = true })
    map("n", "P", "<C-w>z", { desc = "Netrw close preview", remap = true, buffer = true })
  end,
})
