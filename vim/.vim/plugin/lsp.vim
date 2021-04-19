command! Callers execute "lua vim.lsp.buf.incoming_calls()"
command! References execute "lua vim.lsp.buf.references()"
command! Rename execute "lua vim.lsp.buf.rename()"
command! Implementation execute "lua vim.lsp.buf.implementation()"

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
let g:completion_enable_auto_hover = 0
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_trigger_keyword_length = 2 " default = 1
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'},
    \{'mode': 'keyp'},
    \{'mode': 'keyn'},
\]
" possible values for chain list:
"  "<c-n>" : i_CTRL-N
"  "<c-p>" : i_CTRL-P
"  "cmd" : i_CTRL-X_CTRL-V
"  "defs": i_CTRL-X_CTRL-D
"  "dict": i_CTRL-X_CTRL-K
"  "file": i_CTRL-X_CTRL-F
"  "incl": i_CTRL-X_CTRL-I
"  "keyn": i_CTRL-X_CTRL-N
"  "keyp": i_CTRL-X_CTRL-P
"  "omni": i_CTRL-X_CTRL-O
"  "line": i_CTRL-X_CTRL-L
"  "spel": i_CTRL-X_s
"  "tags": i_CTRL-X_CTRL-]
"  "thes": i_CTRL-X_CTRL-T
"  "user": i_CTRL-X_CTRL-U
