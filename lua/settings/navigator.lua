local navigator = require("Navigator")
navigator.setup()

-- stylua: ignore start
vim.keymap.set("n", "<C-h>", navigator.left, { silent = true, desc = "navigate to left window or tmux pane" })
vim.keymap.set("n", "<C-k>", navigator.up, { silent = true, desc = "navigate to upper window or tmux pane" })
vim.keymap.set("n", "<C-l>", navigator.right, { silent = true, desc = "navigate to right window or tmux pane" })
vim.keymap.set("n", "<C-j>", navigator.down, { silent = true, desc = "navigate to lower window or tmux pane" })
-- stylua: ignore end
