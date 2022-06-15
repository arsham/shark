vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.opt_local.formatoptions:remove({ "t" })

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.expandtab = false

vim.api.nvim_command("compiler go")
