vim.wo.conceallevel = 0
vim.schedule(function()
  vim.bo.syntax = "help"
  pcall(vim.treesitter.start)
end)
