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

" required for vim-ctrlspace
let g:CtrlSpaceDefaultMappingKey = "<C-space> "
"nautocmd VimEnter * Tmuxline lightline
hi VertSplit ctermbg=NONE guibg=NONE            " remove the background of the vertical splitter
highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE
" highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
" highlight CursorLineNr     ctermfg=7    ctermbg=8       cterm=none
" highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
" highlight Statement        ctermfg=2    ctermbg=none    cterm=none
" highlight Directory        ctermfg=4    ctermbg=none    cterm=none
" highlight StatusLine       ctermfg=7    ctermbg=8       cterm=none
" highlight StatusLineNC     ctermfg=7    ctermbg=8       cterm=none
" highlight NERDTreeClosable ctermfg=2
" highlight NERDTreeOpenable ctermfg=8
" highlight Comment          ctermfg=4    ctermbg=none    cterm=italic
" highlight Comment          ctermfg=4    ctermbg=none    cterm=italic
" highlight Constant         ctermfg=12   ctermbg=none    cterm=none
" highlight Special          ctermfg=4    ctermbg=none    cterm=none
" highlight Identifier       ctermfg=6    ctermbg=none    cterm=none
" highlight PreProc          ctermfg=5    ctermbg=none    cterm=none
" highlight String           ctermfg=12   ctermbg=none    cterm=none
" highlight Number           ctermfg=1    ctermbg=none    cterm=none
" highlight Function         ctermfg=1    ctermbg=none    cterm=none

" show hidden whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
" let g:better_whitespace_enabled=1
" let g:better_whitespace_enabled = 0              " Dont' highlight whitespace in red
" let g:strip_whitespace_on_save = 1
" let g:strip_whitespace_confirm = 0               " Don't ask for confirmation when deleting whitespace

" let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
" let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
" let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
"let g:gitgutter_sign_modified_removed = "✂️'"
