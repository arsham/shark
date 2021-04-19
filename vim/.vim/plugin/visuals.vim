set laststatus=2
set colorcolumn=80
set autoindent
set encoding=utf-8
set tabstop=4 expandtab shiftwidth=4 softtabstop=4 "go-compatible tab setup
"set foldlevelstart=99 "start file with all folds opened
set relativenumber
set cursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Fix Vim's ridiculous line wrapping model
set ww=<,>,[,],h,l

" vnoremap < <gv "Better Indention
" vnoremap > >gv "Better Indention
" better whitespace settings
let g:strip_whitelines_at_eof = 1
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0
