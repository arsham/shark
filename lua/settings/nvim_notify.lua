local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
    vim.notify = require('notify')
    async_load_plugin:close()
end))
async_load_plugin:send()
