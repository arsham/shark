set laststatus=2
set colorcolumn=80
set autoindent
set encoding=utf-8
set tabstop=4 expandtab shiftwidth=4 softtabstop=4 "go-compatible tab setup
set foldmethod=indent foldlevel=99 "python-compatible folding
set foldlevelstart=99 "start file with all folds opened
set relativenumber
set cursorline
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set background=dark
set t_Co=256
set fillchars+=vert:│

" let g:rehash256 = 1

" colorscheme molokai
" colorscheme molokayo
" colorscheme OceanicNext
" colorscheme onedark
colorscheme onehalfdark

augroup TEXTWRAP
    autocmd!
    autocmd Filetype gitcommit setlocal textwidth=76 colorcolumn=77
augroup END

