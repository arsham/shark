vim.opt.background = 'dark'
vim.opt.guifont = 'DejaVuSansMono Nerd Font:h10'
---Defer setting the colorscheme until the UI loads.
require('util').autocmd{'UIEnter', '*', 'colorscheme arsham_light'}
