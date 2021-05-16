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

func! OverrideHighlights() abort
    hi Normal ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi EndOfBuffer ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi SignColumn ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi Tabline ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi TablineFill ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi BlueSign ctermfg=110 ctermbg=236 guifg=#6dcae8 guibg=#232627
    hi GreenSign ctermfg=107 ctermbg=236 guifg=#9ed06c guibg=#232627
    hi RedSign ctermfg=203 ctermbg=236 guifg=#fb617e guibg=#232627

    " remove the background of the vertical splitter
    hi VertSplit ctermbg=NONE guibg=NONE
    hi Visual cterm=bold ctermbg=Blue guibg=#41444F
    hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
    hi IncSearch guibg=#E388D5 ctermbg=green term=underline
    hi VertSplit ctermfg=237 guifg=#888822
    hi ExtraWhitespace ctermbg=red guibg=red
    hi ColorColumn ctermbg=52 guibg=#2E2A2A

    " popups
    hi Pmenu guibg=#3B404D ctermbg=236 guifg=#dcdfe4 ctermfg=188

    hi ALEError ctermbg=167 ctermfg=Black
    hi ALEWarning ctermbg=179 ctermfg=Black

    " Terminal colours.
    unlet g:terminal_color_0
    unlet g:terminal_color_1
    unlet g:terminal_color_2
    unlet g:terminal_color_3
    unlet g:terminal_color_4
    unlet g:terminal_color_5
    unlet g:terminal_color_6
    unlet g:terminal_color_7
    unlet g:terminal_color_8
    unlet g:terminal_color_9
    unlet g:terminal_color_10
    unlet g:terminal_color_11
    unlet g:terminal_color_12
    unlet g:terminal_color_13
    unlet g:terminal_color_14
    unlet g:terminal_color_15
endfunction

augroup OverrideSonokaiColors
    autocmd!
    autocmd ColorScheme sonokai call OverrideHighlights()
augroup END

let g:sonokai_disable_italic_comment = 1
let g:sonokai_style = 'andromeda'
colorscheme sonokai

if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --hidden
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Mappings
let mapleader = " "

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
" Disable Ex mode
nmap Q <Nop>

" make the regular expression less crazy
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Moving lines with alt key.
nnoremap <A-j> :<c-u>execute 'm +'. v:count1<cr>==
nnoremap <A-k> :<c-u>execute 'm -1-'. v:count1<cr>==

inoremap <A-j> <Esc>:<c-u>execute 'm +'. v:count1<cr>==gi
inoremap <A-k> <Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Keep the visually selected area when indenting.
xnoremap < <gv
xnoremap > >gv

" Re-indent the whole file.
nnoremap g= gg=Gg``

" insert empty lines with motions, can be 10[<space>
nnoremap <silent> [<space>  :<c-u>put!=repeat([''],v:count)<bar>']+1<cr>
nnoremap <silent> ]<space>  :<c-u>put =repeat([''],v:count)<bar>'[-1<cr>

nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Auto re-centre when moving around
nmap G Gzz
nnoremap g; g;zz
nnoremap g, g,zz

" put numbered motions in the jumplist.
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Clear hlsearch
nnoremap <silent> <Esc><Esc> :<C-u>:nohlsearch<CR>

" Terminal mappings.
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-w><C-h> <C-\><C-N><C-w>h
tnoremap <C-w><C-j> <C-\><C-N><C-w>j
tnoremap <C-w><C-k> <C-\><C-N><C-w>k
tnoremap <C-w><C-l> <C-\><C-N><C-w>l

" Add comma at the end of the line.
inoremap <M-,> <Esc>m`A,<Esc>``a
nnoremap <M-,> m`A,<Esc>``

" Add period at the end of the line.
inoremap <M-.> <Esc>m`A.<Esc>``a
nnoremap <M-.> m`A.<Esc>``

" Insert a pair of brackets and go into insert mode.
inoremap <M-{> <Esc>A {<CR>}<Esc>O
nnoremap <M-{> A {<CR>}<Esc>O

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" select a text, and this will replace it with the " contents.
vnoremap <leader>p "_dP

" let the visual mode use the period. To add " at the begining of all lines:
" I:<ESC>j0vG.
vnoremap . :norm.<CR>

" auto correct spelling and jump back.
function! s:FixLastSpellingError()
    let l:currentspell=&spell
    setlocal spell
    normal! [s1z=``
    let &l:spell=l:currentspell
endfunction
nnoremap <leader>sp :call <SID>FixLastSpellingError()<cr>

nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>


augroup FILETYPE_COMMANDS
    autocmd! * <buffer>
    autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd Filetype make,automake setlocal noexpandtab
    autocmd Filetype markdown setlocal spell
    autocmd Filetype gitcommit setlocal spell textwidth=76 colorcolumn=77
    autocmd BufNewFile,BufRead .*aliases set ft=sh

    " Ensure tabs don't get converted to spaces in Makefiles.
    autocmd FileType make setlocal noexpandtab

    " highlight yanking
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()

    " resize Split When the window is resized
    autocmd VimResized * :wincmd =
augroup END
