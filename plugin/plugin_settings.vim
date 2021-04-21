" These are options to disable various stuff in order to let other things
" working properly.
"
" Disabling vim-better-whitespace bindings
let g:better_whitespace_operator=''

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


let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)

" winresizer
let g:winresizer_vert_resize = 5
let g:winresizer_horiz_resize = 1

" better whitespace settings
let g:strip_whitelines_at_eof = 1
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

" fzf

set rtp+=~/.fzf
" ctrl+p -> @ and : implementation like sublime
function! s:goto_def(lines) abort
  silent! exe 'e +BTags '.a:lines[0]
  call timer_start(10, {-> execute('startinsert') })
endfunction
function! s:goto_line(lines) abort
  silent! exe 'e '.a:lines[0]
  call timer_start(10, {-> feedkeys(':') })
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ '@': function('s:goto_def'),
  \ ':': function('s:goto_line')
  \  }

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
" https://github.com/junegunn/fzf.vim/issues/162
let g:fzf_commands_expect = 'enter'
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
let g:fzf_buffers_jump = 1          " [Buffers] Jump to the existing window if possible
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Ale
" \ 'go': ['golangci-lint', 'govet', 'golint', 'remove_trailing_lines', 'trim_whitespace']
let g:ale_linters = {
    \ 'go': ['golangci-lint', 'remove_trailing_lines', 'trim_whitespace']
    \}
"let g:ale_linter_aliases = {'go': ['golangci-lint']}

let g:ale_go_golangci_lint_options = '--fast --build-tags=integration'
" let b:ale_go_golint_options = '-tags=integration'
let g:ale_go_golangci_lint_package=1
let g:ale_sign_column_always = 1
let g:ale_list_window_size = 5

let g:ale_echo_msg_format = '%severity%: %linter%: %s'
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1                   " fix files on save
let g:powerline#extensions#ale#enabled = 1

let g:ale_set_loclist = 1
" let g:ale_set_quickfix = 1
let g:ale_open_list = 1

let g:ale_sign_error = '💣'
let g:ale_sign_warning = '❗'
let g:ale_sign_info = 'ℹ️'

let g:LargeFile = 512                  " anything larger than 512MB is going to be ignores by syntax highlighting, events, etc.

if exists(':NvimTreeToggle')
let g:nvim_tree_width = 40
let g:nvim_tree_ignore = [ '.git', 'node_modules']
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the tree. See :help nvim_tree_lsp_diagnostics
let g:nvim_tree_icons = {
            \ 'default': '',
            \ 'symlink': '',
            \ 'git': {
            \   'unstaged': "✗",
            \   'staged': "✓",
            \   'unmerged': "",
            \   'renamed': "➜",
            \   'untracked': "★",
            \   'deleted': "",
            \   'ignored': "◌"
            \   },
            \ 'folder': {
            \   'default': "",
            \   'open': "",
            \   'empty': "",
            \   'empty_open': "",
            \   'symlink': "",
            \   'symlink_open': "",
            \   }
            \ }

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue
endif

" Ripgrep
let g:rg_derive_root='true'
let g:rg_command = 'rg --vimgrep --hidden --smart-case'

let g:undotree_WindowLayout = 4

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = "nvim_lsp"
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\    'func': "\uf794 ",
\    'function': "\uf794 ",
\    'functions': "\uf794 ",
\    'var': "\uf71b ",
\    'variable': "\uf71b ",
\    'variables': "\uf71b ",
\    'const': "\uf8ff ",
\    'constant': "\uf8ff ",
\    'constructor': "\uf976 ",
\    'method': "\uf6a6 ",
\    'package': "\ue612 ",
\    'packages': "\ue612 ",
\    'enum': "\uf702 ",
\    'enummember': "\uf282 ",
\    'enumerator': "\uf702 ",
\    'module': "\uf136 ",
\    'modules': "\uf136 ",
\    'type': "\uf7fd ",
\    'typedef': "\uf7fd ",
\    'types': "\uf7fd ",
\    'field': "\uf30b ",
\    'fields': "\uf30b ",
\    'macro': "\uf8a3 ",
\    'macros': "\uf8a3 ",
\    'map': "\ufb44 ",
\    'class': "\uf0e8 ",
\    'augroup': "\ufb44 ",
\    'struct': "\uf318 ",
\    'union': "\ufacd ",
\    'member': "\uf02b ",
\    'target': "\uf893 ",
\    'property': "\ufab6 ",
\    'interface': "\uf7fe ",
\    'namespace': "\uf475 ",
\    'subroutine': "\uf9af ",
\    'implementation': "\uf776 ",
\    'typeParameter': "\uf278 ",
\    'default': "\uf29c ",
\  }
let g:vista_close_on_jump = 1

" let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
" let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
" let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
let g:gitgutter_sign_modified_removed = "✂️'"
