vim.opt.termguicolors = true
vim.g.loaded_matchit = 1
require("plugins")

require("options")
require("autocmd")
require("mappings")

vim.schedule(function()
  require("textobjects")
  require("commands")
  require("scratch")
end)

-- stylua: ignore start
vim.defer_fn(function() vim.cmd.doautocmd("User LoadTicker1") end, 100)
vim.defer_fn(function() vim.cmd.doautocmd("User LoadTicker2") end, 200)
vim.defer_fn(function() vim.cmd.doautocmd("User LoadTicker3") end, 300)
