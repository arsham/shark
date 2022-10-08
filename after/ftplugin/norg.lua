vim.opt_local.conceallevel = 2
vim.opt_local.textwidth = 119
vim.opt_local.colorcolumn = "120"
vim.opt_local.foldlevel = 2
vim.keymap.set(
  "n",
  "<localleader>om",
  ":Neorg keybind norg core.looking-glass.magnify-code-block<CR>",
  { buffer = true }
)
vim.opt_local.spell = true
