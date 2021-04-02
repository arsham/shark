set incsearch
set ignorecase
set smartcase
set path=.,**,~/Projects/**                    " Searches current directory recursively.
set showmatch

if executable('rg')
    let g:rg_derive_root='true'
endif
set wildignore+=**/node_modules/**,**/bin/**,**/tmp/**,**/thesaurus/**

