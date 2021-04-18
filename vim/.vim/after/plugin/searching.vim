set incsearch
set ignorecase
set nohlsearch
" allow for live substitution
set inccommand=nosplit
set smartcase
" Searches current directory recursively.
set path=.,**,~/Projects/**
set showmatch

set wildignore+=**/node_modules/**,**/bin/**,**/tmp/**,**/thesaurus/**

" Clear hlsearch
nnoremap <silent> <Esc><Esc> :<C-u>:nohlsearch<CR>
set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden
