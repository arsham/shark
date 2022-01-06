local navigator = require("Navigator")
navigator.setup()

-- stylua: ignore start
vim.keymap.set("n", "<C-h>", navigator.left, { noremap = true, silent = true, desc = "navigate to left window or tmux pane" })
vim.keymap.set("n", "<C-k>", navigator.up, { noremap = true, silent = true, desc = "navigate to upper window or tmux pane" })
vim.keymap.set("n", "<C-l>", navigator.right, { noremap = true, silent = true, desc = "navigate to right window or tmux pane" })
vim.keymap.set("n", "<C-j>", navigator.down, { noremap = true, silent = true, desc = "navigate to lower window or tmux pane" })
-- stylua: ignore end
