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
