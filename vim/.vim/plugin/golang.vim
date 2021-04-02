"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/fatih/vim-go/wiki/Tutorial

"  :AV                        | open alternative file in vertical
"  :GoDoc       , K
"  :GoDocBrowser
"  :GoDecls                   | symbols
"  :GoInfo                    | function signature
"  :GoSameIds                 | Highlight identifiers
"  :GoSameIdsClear            | Clear highlight identifiers
"  :GoReferrers               | Find references to identifier
"  :GoRename <newname>        | Rename identifier
"  :GoDescribe                | Info for identifier
"  :GoFiles                   | List files in a package
"  :GoDeps                    | List file dependencies
"  :GoImpl                    | To implement an interface
"  :GoLint
"  :GoVet
"  :GoMetaLinter
"  :cclose                    | close the result thingy
"  :cnext  , :cn              | next issue
"  :cprev  , :cp              | prev issue
"  :GoImplements              | Interfaces a type implements
"  :GoWhicherrs               | Possible error types
"  :GoChannelPeers            | Channel info
"  :GoCallees                 | Show possible call targets of cunction call
"  :GoCallers                 | Show function call locations
"  :GoCallstack
"  :GoFreevars                | Show free variables visual select +
"  f                          | function object
"  c                          | comment object
"  ]]                         | to next function object
"  [[                         | to previous function object


augroup VIMGO
    autocmd!
    autocmd FileType go inoremap <tab> <C-x><C-o>
    autocmd FileType go nnoremap gd :GoDef<cr>
    autocmd FileType go nnoremap gp :GoDefPop<cr>
    autocmd FileType go nnoremap gimpl :GoImplements<cr>
    autocmd FileType go nnoremap gref :GoReferrers<cr>
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" let g:go_debug=['shell-commands']         " for debugging
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_auto_type_info = 1                 " Automatically get signature/type info for object under cursor
let g:go_updatetime = 100                   " delay for when a job starts
" let g:go_doc_popup_window = 1               " open docs in popup
let g:go_rename_command = 'gopls'

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_doc_max_height = 30
"let g:go_auto_sameids = 1                 " auto same id highlighting

let g:go_fmt_command = 'goimports'    " Run goimports along gofmt on each save
let g:go_imports_autosave = 1

let g:go_list_type = 'quickfix'
let g:go_def_mapping_enabled=0              " to prevent swallowing the ctrl-t

let g:go_addtags_transform = "camelcase"



" GoMetaLinter settings (using ale instead)
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_command = "golangci-lint"
" let g:go_metalinter_enabled = ['vet', 'golint']
" vim.g.go_metalinter_autosave_enabled = {}
" Go to definition and type definition in new tab

" nmap <silent> gD :tab split<CR><Plug>(coc-definition)
" nmap <silent> gY :tab split<CR><Plug>(coc-type-definition)









"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gotags / tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_ctags_bin = '/usr/bin/ctags'
let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;v:variable;f:function'
