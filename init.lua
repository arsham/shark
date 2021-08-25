-- To profile enable the plugin the init.lua and run:
-- env AK_PROFILER=1 nvim -c 'q' 2>&1 >/dev/null | less
-- local profiler = require('profiler')
-- profiler.wrap(require('plugins'))
-- profiler.wrap(require('options'))
-- profiler.wrap(require('visuals'))
-- profiler.wrap(require('autocmd'))
-- profiler.wrap(require('mappings'))
-- profiler.wrap(require('textobjects'))
-- profiler.wrap(require('commands'))
-- profiler.wrap(require('matching'))
-- profiler.wrap(require('lists'))

-- Set to true to show the profile times on startup.
vim.g.run_profiler = false
local profiler = require('util').profiler
profiler('plugins',  function() require('plugins')  end)
profiler('options',  function() require('options')  end)
profiler('visuals',  function() require('visuals')  end)
profiler('autocmd',  function() require('autocmd')  end)
profiler('mappings', function() require('mappings') end)

local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
    profiler('textobjects', function() require('textobjects') end)
    profiler('commands',    function() require('commands')    end)
    profiler('matching',    function() require('matching')    end)
    profiler('lists',       function() require('lists')       end)
    async_load_plugin:close()
end))
async_load_plugin:send()
