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
set fillchars+=vert:│
colorscheme onehalfdark
"colorscheme onedark_nvim

augroup TEXTWRAP
    autocmd!
    autocmd Filetype gitcommit setlocal textwidth=76 colorcolumn=77
augroup END

" required for vim-ctrlspace
let g:CtrlSpaceDefaultMappingKey = "<C-space> "

" remove the background of the vertical splitter
hi VertSplit ctermbg=NONE guibg=NONE
hi Visual cterm=bold ctermbg=Blue ctermfg=NONE
hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
hi IncSearch guibg=#E388D5 ctermbg=green term=underline
hi VertSplit ctermfg=237 guifg=#888822
hi ExtraWhitespace ctermbg=red guibg=red

" let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
" let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
" let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
let g:gitgutter_sign_modified_removed = "✂️'"

" Fix Vim's ridiculous line wrapping model
set ww=<,>,[,],h,l
" vnoremap < <gv "Better Indention
" vnoremap > >gv "Better Indention
