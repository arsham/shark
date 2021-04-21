" Use vim settings rather then vi.
set nocompatible                " must be first.

let with_tagbar = 0
let with_fugitive = 1

filetype off

let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin(stdpath('data') . '/plugged')

    "{{{ Core/System utilities }}}
        Plug 'kyazdani42/nvim-tree.lua'
        Plug 'vim-scripts/LargeFile'              " enhances opening very large files
        Plug 'itchyny/vim-qfedit'
        Plug 'kevinhwang91/nvim-bqf'               " popup floating window on quickfix list
        Plug 'gcmt/taboo.vim'
        Plug 'tweekmonster/startuptime.vim'

    "{{{ git }}}
        Plug 'tpope/vim-fugitive', Cond(with_fugitive)
        Plug 'nvim-lua/plenary.nvim'        " dependency for other plugins
        Plug 'lewis6991/gitsigns.nvim'

    "{{{ Visuals }}}
        Plug 'sainnhe/sonokai'
        Plug 'hoob3rt/lualine.nvim'
        Plug 'adelarsq/vim-devicons-emoji'
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'ntpeters/vim-better-whitespace'
        Plug 'dhruvasagar/vim-zoom'
        " Plug 'kshenoy/vim-signature'                           " Display and navigate marks
        Plug 'simeji/winresizer'

    "{{{ Editing }}}
        Plug 'mbbill/undotree'
        Plug 'tpope/vim-commentary'
        Plug 'tpope/vim-repeat'                           " add support for period (.) to unsupported plugins
        " try this: windwp/nvim-autopairs
        Plug 'jiangmiao/auto-pairs'
        Plug 'arthurxavierx/vim-caser'                    " case conversion
        Plug 'junegunn/vim-easy-align'
        " Plug 'sirver/ultisnips'                         " sometimes buggy
        " Plug 'honza/vim-snippets'

    "{{{ Searching }}}
        Plug 'jremmen/vim-ripgrep'
        Plug 'junegunn/fzf'                                ",  { 'dir': $HOME.'/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'

    "{{{ Languages }}}
        Plug 'neovim/nvim-lspconfig'
        Plug 'dense-analysis/ale'
        Plug 'nvim-lua/completion-nvim'
        Plug 'preservim/tagbar', Cond(with_tagbar)                          " For setting up ctags
        Plug 'liuchengxu/vista.vim', Cond(! with_tagbar)
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'nvim-treesitter/nvim-treesitter-textobjects'
        Plug 'uarun/vim-protobuf', { 'for': 'proto' }
        Plug 'towolf/vim-helm', { 'for': 'helm' }
        " Plug 'mattn/vim-goimports', { 'for': 'go' }

    "{{{ Text objects }}}

        Plug 'tpope/vim-surround'                     " cs'<q>     cst"     ysiw]
        Plug 'kana/vim-textobj-user'
        Plug 'glts/vim-textobj-comment'                  " comment (c)
        Plug 'lucapette/vim-textobj-underscore'
        Plug 'austintaylor/vim-indentobject'
        " Plug 'bkad/CamelCaseMotion'

    "{{{ SQL }}}
        " Plug 'joereynolds/SQHell.vim'
        " Plug 'vim-scripts/SQLUtilities'  " requires the align plugin below
        " Plug 'vim-scripts/Align'       " conflicts with table mode pluing

    "{{{ Misc }}}
        " Plug 'christoomey/vim-tmux-navigator'
        " https://github.com/kana/vim-submode
        " https://github.com/kana/vim-operator-user


       " Plug '~/Projects/vim/testplug'

call plug#end()
packadd cfilter
filetype plugin indent on                              " required

lua << EOF
require('plugins')
require('lsp')
EOF
