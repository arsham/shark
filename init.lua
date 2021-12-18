vim.opt.termguicolors = true
require('plugins')
if pcall(require, 'astronauta.keymap') then
    require('options')
    require('visuals')
    require('autocmd')
    require('mappings')

    local async_load_plugin = nil
    async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
        require('textobjects')
        require('commands')
        require('matching')
        require('lists')
        require('yanker')
        require('cheater')
        require('scratch')
        async_load_plugin:close()
    end))
    async_load_plugin:send()
end
