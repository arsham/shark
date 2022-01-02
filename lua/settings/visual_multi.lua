local util = require('util')

vim.g.VM_theme = 'ocean'
vim.g.VM_highlight_matches = ''
vim.g.VM_show_warnings = 0
vim.g.VM_silent_exit = 1
vim.g.VM_default_mappings = 1
vim.g.VM_maps = {
    Delete                 = 's',
    Undo                   = '<C-u>',
    Redo                   = '<C-r>',
    ['Select Operator']    = 'v',
    ['Select Cursor Up']   = '<M-C-k>',
    ['Select Cursor Down'] = '<M-C-j>',
    ['Move Left']          = '<M-C-h>',
    ['Move Right']         = '<M-C-l>',
    ['Align']              = '<M-a>',
    ['Find Under']         = '<C-n>',
    ['Find Subword Under'] = '<C-n>',
}

--- these don't work in the above maps.
util.nnoremap{[[<Leader>\]], function()
    vim.fn["vm#commands#add_cursor_at_pos"](0)
end, desc='add cursor at position'}
util.nnoremap{'<Leader>A', function()
    vim.fn["vm#commands#find_all"](0, 1)
end, desc='find all matches'}
