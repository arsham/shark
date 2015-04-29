" https://github.com/shawncplus/dotfiles/blob/master/.vimrc
"
set nocompatible              " be iMproved, required
filetype off                  " required
" filetype on "filetype detection
" filetype plugin indent on "filetype-based indentation
syntax on "syntax

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'powerline/powerline'
Plugin 'tomtom/tcomment_vim'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ervandew/supertab'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'haya14busa/incsearch.vim'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-expand-region'
Plugin 'klen/python-mode'
Plugin 'pangloss/vim-javascript'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-scripts/ZoomWin'
Plugin 'terryma/vim-multiple-cursors'

" Plugin 'stuartherbert/vim-phix-colors'

" Plugin 'mattn/webapi-vim'
" Plugin 'mattn/gist-vim'
" Plugin 'nvie/vim-flake8'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set laststatus=2
set autoindent
set background=dark
set history=999
set tabstop=4 expandtab shiftwidth=4 softtabstop=4 "python-compatible tab setup
set foldmethod=indent foldlevel=99 "python-compatible folding
set nu
set relativenumber
colorscheme molokai
nnoremap ; :

" Airlinebar config
let g:airline_theme='luna'
let g:airline_powerline_fonts=1
set t_Co=256

set encoding=utf-8
set scrolloff=3
set undolevels=10000

set cursorline
set ttyfast
set backspace=indent,eol,start
set listchars=tab:>~,nbsp:_,trail:.
set list

set ignorecase

set smartcase
set incsearch
set showmatch
set hlsearch
set nowritebackup

set clipboard=unnamed
" Auto remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" Mappings

map <C-j> <C-w>j # Jump to buttom pane
map <C-k> <C-w>k # Jump to top pane
map <C-l> <C-w>l # Jump to right pane
map <C-h> <C-w>h # Jump to left pane

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Map sort function to s
vnoremap <Leader>s :sort<CR>

vnoremap < <gv "Better Indention
vnoremap > >gv "Better Indention

no <C-j> ddp # Move line down
no <C-k> ddkP # Move line up

" nmap <C-Tab> :tabnext<CR>
" nmap <C-S-Tab> :tabprevious<CR>
" map <C-S-Tab> :tabprevious<CR>
" map <C-Tab> :tabnext<CR>
" imap <C-S-Tab> <ESC>:tabprevious<CR>
" imap <C-Tab> <ESC>:tabnext<CR>
" noremap <F7> :set expandtab!<CR>
" nmap <Leader>h :tabnew %:h<CR>
"
" "custom comma motion mapping
" nmap di, f,dT,
" nmap ci, f,cT,
" nmap da, f,ld2F,i,<ESC>l "delete argument
" nmap ca, f,ld2F,i,<ESC>a "delete arg and insert
"
" upper or lowercase the current word
" nmap g^ gUiW
" nmap gv guiW
" "open tag in new tab
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"
""quick pairs
"imap <leader>' ''<ESC>i
"imap <leader>" ""<ESC>i
"imap <leader>( ()<ESC>i
"imap <leader>[ []<ESC>i





"==========================================================================="
"" Different search patterns
"let g:cpp_pattern = "*.{cpp,c,h,hpp}"
"let g:java_pattern = "*.{java}"
"let g:makefile_pattern = "Makefile*"
"let g:text_pattern = "*.{txt,text}"
let g:python_pattern = "*.{py}"
"let g:cpp_java_pattern = "*.{cpp,c,h.hpp,java}"

" Rope settings."
inoremap <leader>j <ESC>:RopeGotoDefinition<cr>

" Working with split screen nicely
" Resize Split When the window is resized"
au VimResized * :wincmd =


" Wildmenu completion "
set wildmenu
"set wildmode=list:longest
"set wildignore+=.hg,.git,.svn " Version Controls"
"set wildignore+=*.aux,*.out,*.toc "Latex Indermediate files"
"set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Binary Imgs"
"set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest "Compiled Object files"
"set wildignore+=*.spl "Compiled speolling world list"
"set wildignore+=*.sw? "Vim swap files"
"set wildignore+=*.DS_Store "OSX SHIT"
"set wildignore+=*.luac "Lua byte code"
"set wildignore+=migrations "Django migrations"
"set wildignore+=*.pyc "Python Object codes"
"set wildignore+=*.orig "Merge resolution files"

" Make Sure that Vim returns to the same line when we reopen a file"
augroup line_return
    au!
    au BufReadPost *
           \ if line("'\"") > 0 && line("'\"") <= line("$") |
           \ execute 'normal! g`"zvzz' |
           \ endif
augroup END

nnoremap g; g;zz

""====================================================================
"""""""""""""" Check the following

" Python mode settings
map <Leader>g :call RopeGotoDefinition()<CR>
let ropevim_enable_shortcuts = 1
let g:pymode_rope_goto_def_newwin = "vnew"
let g:pymode_rope_extended_complete = 1
let g:pymode_breakpoint = 0
let g:pymode_syntax = 1
let g:pymode_syntax_builtin_objs = 0
let g:pymode_syntax_builtin_funcs = 0
map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>
" prefs.add('python_path', '~/.virtualenvs/..../site-packages/')

let g:pymode_options_max_line_length = 95

" Better navigation through omnicomplete option list
"set completeopt=longest,menuone
"function! OmniPopup(action)
"    if pumvisible()
"        if a:action == 'j'
"            return "\<C-N>"
"        elseif a:action == 'k'
"            return "\<C-P>"
"        endif
"    endif
"    return a:action
"endfunction
""
"inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
"inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>



" " ================ ReplaceText function ============================
"
" function! MySearchText()
"     let text = input("Text to find: ")
"     :call MySearchSelectedText(text)
" endfunction
"
" function! MySearchSelectedText(text)
"     :execute "vimgrep /" . a:text . "/jg ".g:search_root."/**/".g:search_pattern
" endfunction
"
"
" function! MyReplaceText()
"     let replacee = input("Old text: ")
"     let replacor = input("New text: ")
"     :execute "%s/" . replacee . "/" . replacor. "/gI"
" endfunction
"
" function! MyReplaceSelectedText(oldText)
"     let replacor = input("New text: ")
"     :execute "%s/" . a:oldText . "/" . replacor. "/gI"
" endfunction
"
"
"
" function! PasteAndIndent()
"   normal! l"+P
"   "let lineNumber = line('.')
"   "normal! [{%v%=
"   ":execute lineNumber
" endfunction
"
" " Allow using C-Up and C-Down in insert mode
" " to move between splitted buffers easly
" "imap <C-Up> <Esc><C-Up>i
" "imap <C-Down> <Esc><C-Down>i
"
"
" " Saving file
" "nmap <C-s> :w<cr>
" "imap <C-s> <ESC>:w<cr>i
"
" " Quit without saving
" "nmap <Esc><C-q> :qa!<cr>
" "imap <Esc><C-q> <ESC>:qa!<cr>
"
" " Quit with saving
" "nmap <C-q> :xa!<cr>
" "imap <C-q> <ESC>:xa!<cr>
"
" ""Split window
" "nmap <C-n><C-n> :split <cr>
" "imap <C-n><C-n> <ESC>:split <cr>i
" "nmap <C-b><C-b> :vsplit <cr>
" "imap <C-b><C-b> <ESC>:vsplit <cr>i
"
" "Make window mosaic
" nmap <leader>mon :split<cr>:vsplit<cr><C-Down>:vsplit<cr><C-Up><leader>l
" imap <leader>mon <ESC>:split<cr>:vsplit<cr><C-Down>:vsplit<cr><C-Up><leader>li
"
" "Close splitted window
" "nmap <C-d><C-d> :q! <cr>
" "imap <C-d><C-d> <ESC>l:q! <cr>i
"
" " Undo redo
" "nmap <C-z> u
" "imap <C-z> <ESC>lui
"
" "nmap <C-y> <C-r>
" "imap <C-y> <ESC>l<C-r>i
"
" " Replace command
" nmap <F6> :execute "call MyReplaceText()"<cr>
" imap <F6> <ESC>l:execute "call MyReplaceText()"<cr>
"
" nmap <F7> :execute "call MyReplaceSelectedText(\"".expand('<cword>')."\")" <cr>
" imap <F7> <ESC>l:execute "call MyReplaceSelectedText(\"".expand('<cword>')."\")" <cr>
"
"
" " Make check spelling on or off
" nmap <leader>cson   :set spell<CR>
" nmap <leader>csoff  :set nospell<CR>
"
"
" " Indentation (got to opening bracket and indent section)
"
" "vmap =
" nmap <leader>ip [{=%
" "imap <C-s><C-i> <ESC>l[{=%<cr>i
"
" "Highlight section between brackets (do to opening bracket and highlight)
" nmap <leader>hp [{%v%<Home>
" "imap <C-s><C-h> <ESC>l[{%v%<Home>
"
" "Find commad
"
" "nmap <C-f> /
" "imap <C-f> <ESC>l/
"
"
" "nmap <C-f><C-f> :execute "/" .  expand('<cword>') <cr>
" "imap <C-f><C-f> <ESC>l:execute "/" .  expand('<cword>') <cr>i
"
" "Find in many files and navigate between search results
" "
" map <F3> :call MySearchText() <Bar> botright cw<cr>
" map <F3><F3> :execute "call MySearchSelectedText (\"".expand("<cword>") . "\")" <Bar> botright cw<cr>
" nmap <A-Right> :cnext<cr>
" nmap <A-Left> :cprevious<cr>
"
"
"
" " Go Home/End of document
"
" "nmap <C-b><C-b> gg
" "imap <C-b><C-b> <ESC>ggi
"
" "nmap <C-e><C-e> G
" "imap <C-e><C-e> <ESC>Gi
"
" "Select all text
"
" "vmap <C-a> <ESC>ggvG <End>
" "nmap <C-a> ggvG <End>
" "imap <C-a> <ESC>ggvG <End>
"
" " Close Tab
"
" "nmap <C-d> :BD<cr>
" "imap <C-d> <ESC>:BD><cr>i
"
" " Map copy and paste in visual moderuntime
"
" "nmap <C-c> yiw
" "imap <C-c> <ESC>yiwi
" "vmap <C-x> "+d
" "vmap <C-c> "+yi
" "nmap <C-v> :call PasteAndIndent()<cr>i<Right>
" nmap <leader>pi <ESC>:call PasteAndIndent()<cr>i<Right>
"
" "Cmake
" ":cmake
"
" "Switch between .h and .cpp Files
"
" nmap <leader>th :A <cr>
" "imap <C-a><C-a> <ESC>:A<cr>i
"
" function! FindProjectRoot(lookFor)
"     let pathMaker='%:p'
"     while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
"         let pathMaker=pathMaker.':h'
"         let fileToCheck=expand(pathMaker).'/'.a:lookFor
"         if filereadable(fileToCheck)||isdirectory(fileToCheck)
"             return expand(pathMaker)
"         endif
"     endwhile
"     return 0
" endfunction
"
" function! BuildAndInstallCppApp()
"     let project_root = FindProjectRoot("main.cpp")
"     if project_root == 0
"         let project_root = "."
"     endif
"     execute "!cd ".project_root."/build; sudo make install;"
" endfunction
"
" function! BuildAndInstallCSharpApp()
"     execute "!xbuild;"
" endfunction
"
" function! BuildAndInstallQtApp()
"     execute "!make;"
" endfunction
"
"
" " Quickfix open
" " :copen
"
" " CMake
" nmap <F8> <C-s> :call BuildAndInstallCppApp()<cr>
" imap <F8> <ESC> <C-s> :call BuildAndInstallCppApp()<cr>
"
" " Make
" nmap <C-F8> <C-s> :call BuildAndInstallQtApp()<cr>
" imap <C-F8> <ESC> <C-s> :call BuildAndInstallQtApp()<cr>
"
" " CSharp make
" nmap <C-F5> <C-s> :call BuildAndInstallCSharpApp()<cr>
" imap <C-F5> <ESC> <C-s> :call BuildAndInstallCSharpApp()<cr>
"
"
" " Normal make
" nmap <F9>> :set makeprg=make\ -C\ .<cr> :make --no-print-directory <cr> :TagbarClose<cr> :cw <cr> :TagbarOpen <cr>
" imap <F9> <ESC> set makeprg=make\ -C\ ./build<cr> :make --no-print-directory <cr> :TagbarClose<cr> :cw <cr> :TagbarOpen <cr>i
"
" " Go to function definition
" " <C-]> - go to defintion
" " <C-t> - return from definition
"
" " Snipmate
" " Show list of snippets: <C-r><tab>
" " complate snippet: <tab>
"
"
"
"
" "Tagbar key bindings
" nmap <leader>l <ESC>:TagbarToggle<cr>
"
" " Mini Buffer some settigns."
" let g:miniBufExplMapWindowNavVim = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplModSelTarget = 1
"
"
"
" " Force Saving Files that Require Root Permission
" "
" cmap w!! %!sudo tee > /dev/null %
"
" " TAB and Shift-TAB in normal mode cycle buffers
" "
" nmap <Tab> :bn<CR>
" nmap <S-Tab> :bp<CR>
"
"
"
" " Configure autocomplete tool
" let g:acp_EnableAtStartup = 1
" ""let g:clang_auto_select = 1
" ""let g:clang_close_preview = 1
"
" set laststatus=2
" set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"
"
" set nowrap
" set expandtab
"
" " Edit .vimrc file
" nmap <silent> <leader>ov :e $MYVIMRC<CR>
" nmap <silent> <leader>sv :w<CR> :so $MYVIMRC<CR>
"
" function! BufferIsEmpty()
"     if line('$') == 1 && getline(1) == ''
"         return 1
"     else
"         return 0
"     endif
" endfunction
"
" " Manpage for word under cursor via 'K' in command moderuntime
" runtime ftplugin/man.vim
" noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>
"
" " Map SyntasticCheck to F6
" "
" noremap <silent> <F4> :SyntasticCheck<CR>
" noremap! <silent> <F4> <ESC>:SyntasticCheck<CR>
"
" au BufNewFile,BufRead *.c,*.cc,*.cpp,*.h call SetupCandCPPenviron()
" function! SetupCandCPPenviron()
"     "
"     " Search path for 'gf' command (e.g. open #include-d files)
"     "
"     set path+=/usr/include/c++/**
"
"     "
"     " Especially for C and C++, use section 3 of the manpages
"     "
"     noremap <buffer> <silent> K :exe "Man" 3 expand('<cword>') <CR>
" endfunction
"
"
"
"
" function! UpdateTags()
"     execute ":!ctags -R --sort=yes --fields=+iaSnkt --extra=+q+f --exclude=build -f ~/.vim/tags/last_project_tags `pwd`"
"     echohl StatusLine | echo "C\\C++ tags updated" | echohl None
" endfunction
"
" function! UpdateAllTags()
"     execute ":!ctags -R --sort=yes --fields=+iaSnkt --extra=+q+f --exclude=build -f ~/.vim/tags/last_project_tags `pwd`"
"     "execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSnkt --extra=+q+f -f ~/.vim/tags/usr_local_include /usr/local/include"
"     execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSnkt --extra=+q+f -f ~/.vim/tags/cpp ~/.vim/tags/cpp_src"
"     execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSkt --extra=+q+f -f ~/.vim/tags/opencv /usr/local/include/opencv2"
"     echohl StatusLine | echo "C\\C++ tags updated" | echohl None
" endfunction
"
" function! IsFileAlreadyExists(filename)
"    if filereadable(a:filename)
"         return 1
"     else
"         return 0
"     endif
" endfunction
"
" "Invoke this function if we are opening main.cpp or main.c file"
" function! CheckIfMain()
"     if !IsFileAlreadyExists(expand("%:t")) && expand("%:t:r") == "main" && expand("%:e") == "cpp"
"         execute 'normal! 1G 1000dd'
"         execute ':Template maincpp'
"         execute ':w'
"     elseif !IsFileAlreadyExists(expand("%:t")) && expand("%:t:r") == "main" && expand("%:e") == "c"
"         execute 'normal! 1G 1000dd'
"         execute ':Template mainc'
"         execute ':w'
"     endif
" endfunction
"
" "Invoke this function when you would like to create new C++ class files (.cpp
" "and .h file)"
"
" function! CreateCppClassFiles(className)
"     "create cpp file
"     if !IsFileAlreadyExists(a:className.'.cpp')
"         execute ':n '.a:className.'.cpp'
"         execute 'normal! 1G 1000dd'
"         execute ':Template cppclass'
"         execute ':w'
"     else
"         execute ':n '.a:className.'.cpp'
"     endif
"     "create h file
"     if !IsFileAlreadyExists(a:className.'.h')
"         execute ':n '.a:className.'.h'
"         execute 'normal! 1G 1000dd'
"         execute ':Template cppclassh'
"         execute ':w'
"     else
"         execute ':n '.a:className.'.h'
"     endif
" endfunction
"
" "create new command for creating cpp class"
" command! -nargs=1 NewCppClass call CreateCppClassFiles("<args>")
"
" " setting ctags
" set tags+=~/.vim/tags/last_project_tags
" set tags+=~/.vim/tags/dtv_project
" set tags+=~/.vim/tags/cpp
" set tags+=~/.vim/tags/opencv
" set tags+=~/.vim/tags/qt5
" set tags+=~/.vim/tags/usr_local_include
"
" nmap <leader>go   :split<cr><C-]>
"
" nmap <C-F11> :call UpdateAllTags()<cr>
" imap <C-F11> <ESC>l:call UpdateAllTags()<cr>
"
" nmap <C-F12> :silent call UpdateTags()<cr>:w<cr>
" imap <C-F12> <ESC>l:silent call UpdateTags()<cr>:w<cr>i
"
" set autochdir
" let NERDTreeChDirMode=2
" nnoremap <leader>n :NERDTree .<CR>
" nnoremap <leader>r :NERDTreeFind<cr>
"
" " =========== END Plugin Settings =========="
" "
" "
"
"
" " Save and load session
" "
" map <leader>ss :SessionSaveAs user_auto_saved_session<cr>:NERDTree .<cr>
" map <leader>so :SessionOpen user_auto_saved_session<cr><C-d><C-d>,n:NERDTree .<cr>
"
" ""Open default session (session saved during closing vim)
" map <leader>sd :SessionOpen vim_auto_saved_session<cr>:NERDTree .<cr>
"
" ""let g:session_autosave = 'no'
"
"
" " =========== Startup commands =========="
"
" autocmd VimEnter * SignatureToggleSigns
" autocmd VimEnter * NERDTree .
" autocmd VimEnter * helptags ~/.vim/doc
" autocmd VimEnter * TagbarOpen
" autocmd VimEnter * exe 2 . "wincmd w"
" autocmd VimEnter * call CheckIfMain()
"
" " Map Tab to Esc in order to switch between Modesto
" nnoremap <C-o> i
" inoremap <C-o> <Esc>
" vnoremap <C-o> <Esc>
"
" " =========== Leaving commands =========="
"
" autocmd VimLeave * SessionSaveAs vim_auto_saved_session
"
"
" "============ Configuration Omni Completion =============================="
"
" filetype plugin on
" autocmd FileType python set omnifunc=pythoncomplete#Complete
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS
" autocmd FileType cpp set omnifunc=omni#cpp#complete#Main
"
" " <C-@> is interpreated by terminal vim as <C-Space>
" inoremap <C-@> <C-x><C-o>
"
" if v:version >= 600
"     filetype plugin on
"     filetype indent on
" else
"     filetype on
" endif
"
" if v:version >= 700
"     set omnifunc=syntaxcomplete#Complete " override built-in C omnicomplete with C++ OmniCppComplete plugin
"     "let g:SuperTabDefaultCompletionType = "<C-@>"
"     let OmniCpp_NamespaceSearch     = 1
"     let OmniCpp_GlobalScopeSearch   = 1
"     let OmniCpp_DisplayMode         = 1
"     let OmniCpp_ShowScopeInAbbr     = 0 "do not show namespace in pop-up
"     let OmniCpp_ShowPrototypeInAbbr = 1 "show prototype in pop-up
"     let OmniCpp_ShowAccess          = 1 "show access in pop-up
"     let OmniCpp_SelectFirstItem     = 2 "select first item in pop-up
"     let OmniCpp_MayCompleteDot      = 1
"     let OmniCpp_MayCompleteArrow    = 1
"     let OmniCpp_MayCompleteScope    = 1
"     let OmniCpp_DefaultNamespaces   = ['std','_GLIBCXX_STD']
"
"     set completeopt=menuone,menu,longest,preview
" endif
"
" "================ Ctrl+Shift+Arrows selection ======================================
" "
" ""place in vimrc file
"
" "word selection
" "nmap <C-S-Left> vb
" "nmap <C-S-Right> ve
" "imap <C-S-Left> <Esc><Right>vb
" "imap <C-S-Right> <Esc><Right>ve
" "vmap <C-S-Left> b
" "vmap <C-S-Right> e
"
" ""down/up selection
" "nmap <C-S-Down> v<Down>
" "nmap <C-S-Up> v<Up>
" "imap <C-S-Down> _<Esc>lmz"_xv`zo`z<Down><Right><BS><BS>
" "imap <C-S-Up> _<Esc>lmz"_xv`z<Up>o`z<BS>o
" "vmap <C-S-Down> <Down>
" "vmap <C-S-Up> <Up>
"
" ""home/end selection
" "nmap <C-S-Home> v<Home>
" "nmap <C-S-End> v<End>
" "imap <C-S-Home> _<Esc>lmz"_s<C-o><Left><C-o>`z<Esc>v<Home>
" "imap <C-S-End> _<Esc>lmz"_xv`zo<End>
"
" ""half page down/up selection
" "nmap <C-S-PageDown> v<End><C-d><End>
" "nmap <C-S-PageUp> v<Home><C-u>
" "imap <C-S-PageDown> _<Esc>lmz"_xv`zo<End><C-d><End>
" "imap <C-S-PageUp> _<Esc>lmz"_xv`z<BS>o<Home><C-u>
" "vmap <C-S-PageDown> <End><C-d><End>
" "vmap <C-S-PageUp> <Home><C-u>
"
" ""word deletion
" "imap <C-BS> <C-w>
" "nmap <C-w> i<C-w><Esc>
" "imap <C-Del> _<Esc>lmzew<BS>i<Del><Esc>v`z"_c
"
" "vmap <Del> d<Esc>li
"
" "===================================================================================================
" " Commenting blocks of code.
" autocmd FileType c,cppva,scala let b:comment_leader = '// '
" autocmd FileType sh,ruby,python   let b:comment_leader = '# '
" autocmd FileType conf,fstab       let b:comment_leader = '# '
" autocmd FileType tex              let b:comment_leader = '% '
" autocmd FileType mail             let b:comment_leader = '> '
" autocmd FileType vim              let b:comment_leader = '" '
" noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
" noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>'"'"
"
"
" " ========================================================================================
" " SURRENDINGS
"
" autocmd FileType c,cpp let b:surround_105  = "if (condition) {\n \r } \n"
" autocmd FileType c,cpp let b:surround_102  = "for (int i=0; i<condition;i++) {\n\r}\n"
" autocmd FileType c,cpp let b:surround_119  = "while (condition) {\n\r}\n"
" autocmd FileType c,cpp let b:surround_112  = "printf(\"\r\\n\");"
" autocmd FileType c,cpp let b:surround_99   = "/*\n\r*/"
"
" autocmd FileType html  let b:surround_102  = "<font face=\"courier\">/r</font>"
"
" " ========================================================================================
" "Enable snippets for cpputest
" autocmd FileType cpp :set filetype=cpp.cpputest
" autocmd FileType c   :set filetype=c.cpputest
"
" " ========================================================================================
" " REFRESH COMMANDS
"
" " warning: to refresh NERDTree just type 'r' being in NERD window
"
" nmap <F5> :e<cr>
" imap <F5> <ESC>l:e<cr>i
"
" " ========================================================================================
" " MULTIPLE CLIPBOARD
"
" " In order to paste test from register use:
" " <Ctrl-R><registername>
" " ex. <Ctrl-R>1
"
" vmap ca "ayy<ESC>i
" nmap ca "ayy
" vmap cb "byy<ESC>i
" nmap cb "byy
" vmap cc "cyy<ESC>i
" nmap cc "cyy
" vmap cd "dyy<ESC>i
" nmap cd "dyy
" vmap ce "eyy<ESC>i
" nmap ce "eyy
" vmap cf "fyy<ESC>i
" nmap cf "fyy
" vmap cg "gyy<ESC>i
" nmap cg "gyy
" vmap ch "hyy<ESC>i
" nmap ch "hyy
"
" " ========================================================================================
" " " USING MARKERS
" " Create marker: m<markerSign> ex. ma
" " Goto marker:   '<markerSign> ex. 'a
" "
" " ========================================================================================
" " " INSERT C++ GETTER NAD SETTER
" map <Leader>igs :InsertBothGetterSetter<CR>
"
" " ========================================================================================
" " " USING VIM AS HEX EDITOR
" map <Leader>hon :%!xxd<CR>
" map <Leader>hof :%!xxd -r<CR>
"
" " ========================================================================================
" " " USING TASKLIST
"
" map <leader>td <Plug>TaskList
"
" " ========================================================================================
" " " USING GUNDO (revision of history saving)
"
" map <leader>gu :GundoToggle<CR>
" let g:gundo_width = 60
" let g:gundo_preview_height = 40
" let g:gundo_right = 1
"
" " ========================================================================================
" " " Resize split window horizontally and vertically
" " Shortcuts to Shift-Alt-Up - Alt is mapped as M in vim
" nmap <S-M-Up> :2winc+<cr>
" imap <S-M-Up> <Esc>:2winc+<cr>i
" nmap <S-M-Down> :2winc-<cr>
" imap <S-M-Down> <Esc>:2winc-<cr>i
"
" nmap <S-M-Left> :2winc><cr>
" imap <S-M-Left> <Esc>:2winc><cr>i
" nmap <S-M-Right> :2winc<<cr>
" imap <S-M-Right> <Esc>:2winc<<cr>i
"
" " ========================================================================================
" " " Using Omni completion for C#
"
" let g:OmniSharp_host = "http://localhost:2000"
" let g:OmniSharp_typeLookupInPreview = 1
"
" "nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
"
" "nnoremap <F12> :OmniSharpGotoDefinition<cr>
" "nnoremap gd :OmniSharpGotoDefinition<cr>
" "nnoremap <leader>fi :OmniSharpFindImplementations<cr>
" "nnoremap <leader>ft :OmniSharpFindType<cr>
" "nnoremap <leader>fs :OmniSharpFindSymbol<cr>
" "nnoremap <leader>fu :OmniSharpFindUsages<cr>
" "nnoremap <leader>fm :OmniSharpFindMembersInBuffer<cr>
" "nnoremap <leader>tt :OmniSharpTypeLookup<cr>
" ""I find contextual code actions so useful that I have it mapped to the spacebar
" "nnoremap <space> :OmniSharpGetCodeActions<cr>
" ""
" """ rename with dialog
" "nnoremap <leader>nm :OmniSharpRename<cr>
" "nnoremap <F2> :OmniSharpRename<cr>
" "" rename without dialog - with cursor on the symbol to rename... ':Rename
" "" newname'
" "command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
" "" " Force OmniSharp to reload the solution. Useful when switching branches etc.
"  "nnoremap <leader>rl :OmniSharpReloadSolution<cr>
"  "nnoremap <leader>cf :OmniSharpCodeFormat<cr>
"  "nnoremap <leader>tp :OmniSharpAddToProject<cr>
" "" " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp
" "" server for the current solution
"  "nnoremap <leader>ss :OmniSharpStartServer<cr>
"  "nnoremap <leader>sp :OmniSharpStopServer<cr>
"  "nnoremap <leader>th :OmniSharpHighlightTypes<cr>
" "" "Don't ask to save when changing buffers (i.e. when jumping to a type
" "" definition)
"  "set hidden
 "
"
" " ========================================================================================
" " " ProtoDef plugin
" " ========================================================================================
" " Allows pulling C++ function prototypes into implementation files
" " https://github.com/derekwyatt/vim-protodef
" "
" let g:protodefprotogetter="$HOME/.vim/bundle/vim-protodef/pullproto.pl"
"
"
" " ========================================================================================
" " " localvimrc plugin
" " This plugin searches for local vimrc files in the file system tree of the
" " currently opened file.
" " https://github.com/embear/vim-localvimrc
" " ========================================================================================
" "
" let g:localvimrc_persistent=2
"
"
" " ========================================================================================
" " " gototagwithlinenumber
" " This plugin allows going to file and line_number stored in tag (using ctags)
" " It is useful ex. when we are working with project and have logs for project.
" " Then we can easly switch between logs and real source code using tags + functions
" " ========================================================================================
" "
" nmap <leader>gt :GotoFileWithLineNumTag <cr>
"
"
" " ========================================================================================
" " " Set up folding configuration
" "
" nnoremap <leader>fo :setlocal foldexpr=(getline(v:lnum)=~@/)?0:1 foldmethod=expr fml=0 foldlevelstart=0 foldcolumn=1<CR>
"
" " ========================================================================================
" " " Set up scrolling winding one line up and down
" nnoremap <S-Up> <C-E>
" nnoremap <S-Down> <C-Y>
"
" " ========================================================================================
" " " Automatically go to the end of pasted text
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]
 "
" " ========================================================================================
" " " Quickly select text which I just pasted
" noremap gV `[v`]
"
" " ========================================================================================
" " " Quickly put ; at the end of current line
" "imap <C-j> <end>;
" "nmap <C-j> i<end>;<Esc>
"
" nmap <Leader><Leader> V
"
" " ========================================================================================
" " VIM-expand-region  plugin
" " https://github.com/terryma/vim-expand-region
" "
" vmap v <Plug>(expand_region_expand)
" vmap r <Plug>(expand_region_shrink)
"
" " ========================================================================================
" " VIM-airline  plugin
" " https://github.com/bling/vim-airline
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
"
" function! AirlineInit()
"   let g:airline_section_a = airline#section#create(['mode'])
"   let g:airline_section_c = airline#section#create(['%F'])
" endfunction
" autocmd VimEnter * call AirlineInit()
"
"   let g:airline_theme_patch_func = 'AirlineThemePatch'
"   function! AirlineThemePatch(palette)
"     if g:airline_theme == 'badwolf'
"       for colors in values(a:palette.inactive)
"         let colors[3] = 245
"       endfor
"     endif
"   endfunction
"
" " ========================================================================================
" " VIM-easy-align  plugin
" "
" vmap <Enter> <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
" "nmap <Leader>b <Plug>(EasyAlign)
"
"
" " ========================================================================================
" " VIM-switch  plugin
" " https://github.com/AndrewRadev/switch.vim
" nnoremap - :Switch<cr>
"
"
" " ========================================================================================
" " VIM-signature plugin
" " https://github.com/kshenoy/vim-signature
" nnoremap <leader>st :SignatureToggleSigns<cr>
"
" " ========================================================================================
" " map ctrl+j to ctrl+m (for INSERT mode)in order to be more consistent with bash terminal
" let g:BASH_Ctrl_j='off'
" inoremap <C-j> <C-m>
