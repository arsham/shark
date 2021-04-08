set incsearch
set ignorecase
if has('nvim')
    set inccommand=nosplit                        " allow for live substitution
endif
set smartcase
set path=.,**,~/Projects/**                    " Searches current directory recursively.
set showmatch

if executable('rg')
    let g:rg_derive_root='true'
endif
set wildignore+=**/node_modules/**,**/bin/**,**/tmp/**,**/thesaurus/**

" Clear hlsearch
nnoremap <silent> <Esc><Esc> :<C-u>:nohlsearch<CR>

set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden
