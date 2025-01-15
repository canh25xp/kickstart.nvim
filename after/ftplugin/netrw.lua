local map = vim.keymap.set
map("n", "n", "%", { desc = "Netrw New file", remap = true, buffer = true })
map("n", "r", "R", { desc = "Netrw Rename file", remap = true, buffer = true })
map("n", "H", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
map("n", ".", "gh", { desc = "Netrw Toggle Hidden", remap = true, buffer = true })
-- map("n", "h", "-^", { desc = "Netrw go up", remap = true, buffer = true })
map("n", "l", "l<cr>", { desc = "Netrw open file", remap = true, buffer = true })
map("n", "P", "<C-w>z", { desc = "Netrw close preview", remap = true, buffer = true })
