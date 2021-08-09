-- To profile enable the plugin the init.lua and run:
-- env AK_PROFILER=1 nvim -c 'q' 2>&1 >/dev/null | less
-- local profiler = require('profiler')
-- profiler.wrap(require('plugins'))
-- profiler.wrap(require('core'))
-- profiler.wrap(require('visuals'))
-- profiler.wrap(require('textobjects'))
-- profiler.wrap(require('commands'))
-- profiler.wrap(require('autocmd'))
-- profiler.wrap(require('mappings'))

vim.g.run_profiler = false
local profiler = require('util').profiler

profiler('plugins',     function() require('plugins') end)
profiler('core',        function() require('core') end)
profiler('visuals',     function() require('visuals') end)
profiler('textobjects', function() require('textobjects') end)
profiler('commands',    function() require('commands') end)
profiler('autocmd',     function() require('autocmd') end)
profiler('mappings',    function() require('mappings') end)
