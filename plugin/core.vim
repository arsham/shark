set autoindent
set smartindent
set formatoptions+=n              " smart auto-indent numbered lists.
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set nowrap
" let the h and l go out of the boundry of a line.
set whichwrap+=h,l
set linebreak               " Wrap lines at convenient points

set list listchars=tab:\ \ ,trail:·
set ttyfast
set clipboard+=unnamed
set title
set titlestring=%t
set number
set relativenumber
set lazyredraw

set backspace=indent,eol,start                " allow backspace in insert mode
set history=10000

set shada=!,'1000,<500,s10,h,f1,:100000,@100000,/100000
set showcmd
set showmode

" auto reload file if changed, need the following two
" reload files changed outside vim
set autoread
au FileChangedShell * echo "Warning: File changed on disk"
" au FocusGained,BufEnter * : checktime

set shortmess+=f	   " Use "(3 of 5)" instead of "(file 3 of 5)"
set shortmess+=i	   " Use "[noeol]" instead of "[Incomplete last line]"
set shortmess+=l	   " Use "999L, 888C" instead of "999 lines, 888 characters"
set shortmess+=m       " Use "[+]" instead of "[Modified]"
set shortmess+=n	   " Use "[New]" instead of "[New File]"
set shortmess+=r	   " Use "[RO]" instead of "[readonly]"
set shortmess+=x	   " Use "[dos]" instead of "[dos format]", "[unix]" instead of [unix format]" and "[mac]" instead of "[mac format]".
" set shortmess+=a	   " All of the above abbreviations
set shortmess+=o	   " Overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
set shortmess+=O	   " Message for reading a file overwrites any previous message.  Also for quickfix message (e.g., ":cn").
set shortmess+=t       " Truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column.  Ignored in Ex mode.
set shortmess+=T	   " Truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle.  Ignored in Ex mode.
set shortmess+=A	   " Don't give the "ATTENTION" message when an existing swap file is found.
set shortmess+=I	   " Don't give the intro message when starting Vim |:intro|.
set shortmess+=c       " Avoid showing message extra message when using completion

set hidden
syntax on

set viewoptions+=localoptions
set viewdir=$HOME/.cache/vim/views

" better diff view. This will make sure the inserted part is separated, rather
" than mangled in the previous blob.
set diffopt+=indent-heuristic
set suffixesadd+=.go
set suffixesadd+=.py
set suffixesadd+=.lua

"enable ctrl-n and ctrl-p to scroll through matches
set wildmenu
set wildmode=longest:full,full
set wildignorecase

"stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~,*.so
set wildignore+=*vim/backups*
set wildignore+=*.git/**,**/.git/**
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=*.pyc
set wildignore+=log/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.zip,*.bg2,*.gz
set wildignore+=*.db
set wildignore+=**/node_modules/**
set wildignore+=**/bin/**
set wildignore+=**/thesaurus/**

set omnifunc=syntaxcomplete#Complete
set updatetime=100

" adds <> to % matchpairs
set matchpairs+=<:>
set complete=.,w,b,u,t,i
set nrformats=bin,hex,alpha           " can increment alphabetically too!
set foldmethod=manual
set foldnestmax=3
set nofoldenable                      "dont fold by default

set spelllang=en_gb
set nospell
set thesaurus+=~/.local/share/thesaurus/moby.txt
" install words-insane package
set dictionary+=/usr/share/dict/words-insane

let s:spellfile=expand("~/.config/nvim/spell")
if !isdirectory(s:spellfile)
    call mkdir(s:spellfile, 'p')
endif
execute 'set spellfile=' . s:spellfile . "/en.utf-8.add"

set scrolloff=3         " keep 3 lines visible while scrolling
set sidescrolloff=15
set sidescroll=1

set incsearch
set ignorecase
set nohlsearch
set inccommand=nosplit         " allow for live substitution
set smartcase
" Searches current directory recursively.
set path=.,**,~/.config/nvim/**
set showmatch

if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" let the visual block mode go over empty characters.
set virtualedit=block
set modelines=0
set nomodeline

set splitbelow splitright
set fillchars+=vert:│

set sessionoptions+=tabpages,globals

set undofile
set undolevels=10000
let s:undodir=expand("~/.cache/nvim/undodir")
let s:backdir=expand("~/.cache/nvim/backdir")

if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
endif
if !isdirectory(s:backdir)
    call mkdir(s:backdir, 'p')
endif

execute 'set undodir=' . s:undodir
execute 'set backupdir=' . s:backdir
execute 'set directory=' . s:backdir

set colorcolumn=80
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
