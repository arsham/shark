local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
    require('dressing').setup({
        input = {
            default_prompt = "➤ ",
            insert_only    = false,
            winblend       = 0,
        },
    })
    async_load_plugin:close()
end))
async_load_plugin:send()
