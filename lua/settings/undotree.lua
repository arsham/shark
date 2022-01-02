vim.g.undotree_CustomUndotreeCmd  = 'vertical 40 new'
vim.g.undotree_CustomDiffpanelCmd = 'botright 15 new'
require('util').nnoremap{'<leader>u', ':UndotreeToggle<CR>', silent=true}
