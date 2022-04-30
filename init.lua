vim.opt.termguicolors = true
require("plugins")
if not pcall(require, "nvim") then
  return
end

require("options")
require("autocmd")
require("mappings")

local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
  require("textobjects")
  require("commands")
  require("scratch")
  async_load_plugin:close()
end))
async_load_plugin:send()
