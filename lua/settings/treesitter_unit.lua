-- stylua: ignore start
vim.keymap.set("x", "iu", ':lua require"treesitter-unit".select()<CR>', { desc = "select in unit" })
vim.keymap.set("x", "au", ':lua require"treesitter-unit".select(true)<CR>', { desc = "select around unit" })
vim.keymap.set("o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>', { desc = "select in unit" })
vim.keymap.set("o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>', { desc = "select around unit" })
-- stylua: ignore end
