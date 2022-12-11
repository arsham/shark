vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.opt_local.formatoptions:remove({ "t" })
vim.bo.expandtab = true
vim.wo.colorcolumn = "80,100,120"

if not vim.opt_local.diff:get() then
  vim.opt_local.foldlevel = 3
end
