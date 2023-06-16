vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.api.nvim_set_option_value("foldmethod", "indent", { scope = "local", win = 0 })
vim.api.nvim_set_option_value("foldlevel", 2, { scope = "local", win = 0 })
