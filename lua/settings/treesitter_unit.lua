local util = require('util')
util.xnoremap{'iu', ':lua require"treesitter-unit".select()<CR>',          desc='select in unit'}
util.xnoremap{'au', ':lua require"treesitter-unit".select(true)<CR>',      desc='select around unit'}
util.onoremap{'iu', ':<c-u>lua require"treesitter-unit".select()<CR>',     desc='select in unit'}
util.onoremap{'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', desc='select around unit'}
