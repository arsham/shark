set rtp=~/dotfiles/tinyvim
set rtp+=~/tmp/tinyvim/site
set rtp+=/etc/xdg/nvim
set rtp+=~/.local/share/flatpak/exports/share/nvim/site
set rtp+=/var/lib/flatpak/exports/share/nvim/site
set rtp+=/usr/share/nvim/site
set rtp+=/usr/share/nvim/runtime
set rtp+=/usr/lib/nvim
set rtp+=/usr/share/nvim/site/after
set rtp+=/usr/local/share/nvim/site/after
set rtp+=/var/lib/flatpak/exports/share/nvim/site/after
set rtp+=~/.local/share/flatpak/exports/share/nvim/site/after
set rtp+=~/dotfiles/tinyvim/site/after
set rtp+=/etc/xdg/nvim/after

filetype off

let data_dir = '~/tmp/tinyvim/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/tmp/tinyvim/plugged')
    Plug 'tweekmonster/startuptime.vim'
    Plug 'sainnhe/sonokai'
call plug#end()
packadd cfilter
filetype plugin on                              " required


set nu
set relativenumber
set hidden
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set nowrap
set undolevels=10000
set title
set history=10000
set showcmd
set showmode
set shortmess=afilnxtToOFAI
" Avoid showing message extra message when using completion
set shortmess+=c
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set updatetime=100
set complete=.,w,b,u,t,i
set foldmethod=manual
set spelllang=en_gb
set nospell
set thesaurus+=~/.local/share/thesaurus/moby.txt
" install words-insane package
set dictionary+=/usr/share/dict/words-insane

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

set noundofile
set noswapfile
set nobackup

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_banner = 0
" let g:netrw_browse_split = 2

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

set background=dark

autocmd ColorScheme sonokai hi Normal ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi EndOfBuffer ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi SignColumn ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi Tabline ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi TablineFill ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi BlueSign ctermfg=110 ctermbg=236 guifg=#6dcae8 guibg=#232627
autocmd ColorScheme sonokai hi GreenSign ctermfg=107 ctermbg=236 guifg=#9ed06c guibg=#232627
autocmd ColorScheme sonokai hi RedSign ctermfg=203 ctermbg=236 guifg=#fb617e guibg=#232627

" remove the background of the vertical splitter
autocmd ColorScheme sonokai hi VertSplit ctermbg=NONE guibg=NONE
autocmd ColorScheme sonokai hi Visual cterm=bold ctermbg=Blue guibg=#41444F
autocmd ColorScheme sonokai hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
autocmd ColorScheme sonokai hi IncSearch guibg=#E388D5 ctermbg=green term=underline
autocmd ColorScheme sonokai hi VertSplit ctermfg=237 guifg=#888822
autocmd ColorScheme sonokai hi ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme sonokai hi ColorColumn ctermbg=52 guibg=#383035

" popups
autocmd ColorScheme sonokai hi Pmenu guibg=#3B404D ctermbg=236 guifg=#dcdfe4 ctermfg=188

autocmd ColorScheme sonokai hi ALEError ctermbg=167 ctermfg=Black
autocmd ColorScheme sonokai hi ALEWarning ctermbg=179 ctermfg=Black

let g:sonokai_disable_italic_comment = 1
let g:sonokai_style = 'andromeda'
colorscheme sonokai

augroup AUTO_NUMBERS
    autocmd!
    autocmd WinEnter,FocusGained,BufEnter,VimEnter * set relativenumber
    autocmd WinLeave,FocusLost * set norelativenumber
augroup END

if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
