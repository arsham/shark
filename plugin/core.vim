set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set nowrap
"Wrap lines at convenient points
set linebreak
set cursorline
" set list lcs=tab:\┆\ " KEEP THIS SPACE      " needs to be here otherwise vim-go stops the indentLine
set list listchars=tab:\ \ ,trail:·
set undolevels=10000
set ttyfast
set clipboard+=unnamed
set title
set number
set relativenumber
" allow backspace in insert mode
set backspace=indent,eol,start
set history=10000
" show commands at the bottom of the screen
set showcmd
set showmode
" auto reload file if changed, need the following two
" reload files changed outside vim
set autoread
au FileChangedShell * echo "Warning: File changed on disk"
" au FocusGained,BufEnter * : checktime
set shortmess=afilnxtToOFAI
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
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=*.pyc
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.zip,*.bg2,*.gz
set wildignore+=*.db
set wildignore+=**/node_modules/**
set wildignore+=**/bin/**
" set wildignore+=**/tmp/**
set wildignore+=**/thesaurus/**
" show possible completions.
" set wildchar=<TAB>
" To invoke: CTRL-X CTRL-O
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

" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave * silent! mkview
"   autocmd BufWinEnter * silent! loadview
" augroup END
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
set path=.,**,~/Projects/**
set showmatch

set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden

set modelines=0
set nomodeline

set splitbelow splitright
" Removes pipes | that act as seperators on splits
set fillchars+=vert:│

set sessionoptions+=tabpages,globals

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
