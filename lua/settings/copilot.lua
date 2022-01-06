local nvim = require("nvim")

-- stylua: ignore start
vim.keymap.set("i", "<C-y>", [[copilot#Accept("\<CR>")]],
  { noremap = true, silent = true, expr = true, script = true, desc = "copilot accept suggestion" }
)
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set("n", "<leader>ce", ":Copilot enable<cr>",
  { noremap = true, silent = true, desc = "enable copilot" }
)
vim.keymap.set("n", "<leader>cd", ":Copilot disable<cr>",
  { noremap = true, silent = true, desc = "disable copilot" }
)
-- stylua: ignore end
--- disabled by default
nvim.ex.Copilot("disable")
