vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')

vim.bo.comments = 's1:/*,mb:*,ex:*/,://'
vim.bo.commentstring = '//\\ %s'
vim.bo.expandtab = false

vim.cmd('compiler go')
