vim.wo.conceallevel = 0
vim.schedule(function()
  vim.bo.syntax = "help"
  vim.treesitter.start()
end)
