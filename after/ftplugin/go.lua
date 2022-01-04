local nvim = require('nvim')

vim.bo.tabstop       = 4
vim.bo.shiftwidth    = 4
vim.bo.softtabstop   = 4
vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')

vim.bo.comments = 's1:/*,mb:*,ex:*/,://'
vim.bo.expandtab = false

nvim.ex.compiler('go')
