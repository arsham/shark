local sqls_settings_group = vim.api.nvim_create_augroup("SQLS_SETTINGS", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = sqls_settings_group,
  pattern = "sqls_output",
  callback = function()
    vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
  end,
})
