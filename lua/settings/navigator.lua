local util = require('util')
local navigator = require('Navigator')
navigator.setup()

util.nnoremap{"<C-h>", navigator.left,  silent=true, desc='navigate to left window or tmux pane'}
util.nnoremap{"<C-k>", navigator.up,    silent=true, desc='navigate to upper window or tmux pane'}
util.nnoremap{"<C-l>", navigator.right, silent=true, desc='navigate to right window or tmux pane'}
util.nnoremap{"<C-j>", navigator.down,  silent=true, desc='navigate to lower window or tmux pane'}
