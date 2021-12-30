local bufname = vim.fn.bufname()
if vim.fn.getbufvar(bufname, 'ftplugin_loaded') == true then return end
vim.fn.setbufvar(bufname, 'ftplugin_loaded', true)

vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
