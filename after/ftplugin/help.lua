vim.api.nvim_set_option_value("conceallevel", 0, { scope = "local", win = 0 })
vim.schedule(function()
  vim.bo.syntax = "help"
  pcall(vim.treesitter.start)
end)
