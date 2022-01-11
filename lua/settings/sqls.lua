vim.keymap.set(
  "n",
  "<C-Space>",
  ":SqlsExecuteQuery<CR>",
  { noremap = true, buffer = true, silent = true }
)
vim.keymap.set(
  "v",
  "<C-Space>",
  ":SqlsExecuteQuery<CR>",
  { noremap = true, buffer = true, silent = true }
)
