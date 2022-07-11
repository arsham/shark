local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
  local notify = require("notify")
  notify.setup({
    timeout = 3000,
  })
  vim.notify = notify
  async_load_plugin:close()
end))
async_load_plugin:send()
