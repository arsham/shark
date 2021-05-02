set autoindent
set smartindent
" smart auto-indent numbered lists.
set formatoptions+=n
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set nowrap
" let the h and l go out of the boundry of a line.
set whichwrap+=h,l

"Wrap lines at convenient points
set linebreak
" set cursorline

" set list lcs=tab:\┆\ " KEEP THIS SPACE      " needs to be here otherwise vim-go stops the indentLine
set list listchars=tab:\ \ ,trail:·
set ttyfast
set clipboard+=unnamed
set title
set titlestring=%t
set number
set relativenumber
set lazyredraw

" allow backspace in insert mode
set backspace=indent,eol,start
set history=10000

set shada=!,'1000,<500,s10,h,f1,:100000,@100000,/100000

set showcmd
set showmode

" auto reload file if changed, need the following two
" reload files changed outside vim
set autoread
au FileChangedShell * echo "Warning: File changed on disk"
" au FocusGained,BufEnter * : checktime

set shortmess=afilnxtToOFAI
" Avoid showing message extra message when using completion
set shortmess+=c

set hidden
syntax on

set viewoptions+=localoptions
set viewdir=$HOME/.cache/vim/views

" better diff view. This will make sure the inserted part is separated, rather
" than mangled in the previous blob.
set diffopt+=indent-heuristic
set suffixesadd+=.go,.py

"enable ctrl-n and ctrl-p to scroll thru matches
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

" can increment alphabetically too!
set nrformats=bin,hex,alpha

set foldmethod=manual
"deepest fold is 3 levels
set foldnestmax=3
"dont fold by default
set nofoldenable

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
" allow for live substitution
set inccommand=nosplit
set smartcase
" Searches current directory recursively.
set path=.,**,~/.config/nvim/**
set showmatch

if executable("rg")
    " set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden\ --glob\ \"!.git/*\"
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

set undolevels=10000
let s:undodir=expand("~/.cache/nvim/undodir")
let s:backdir=expand("~/.cache/nvim/backdir")

if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
endif
if !isdirectory(s:backdir)
    call mkdir(s:backdir, 'p')
endif

set undofile
"set noswapfile
"set nobackup

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
