" Disabling vim-better-whitespace bindings
let g:better_whitespace_operator=''

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsExpandTrigger="<c-s>"

let g:completion_enable_auto_hover = 0
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_trigger_keyword_length = 2 " default = 1
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = [
            \ {'complete_items': ['lsp', 'snippet']},
            \ {'mode': '<c-p>'},
            \ {'mode': '<c-n>'},
            \ {'mode': 'keyp'},
            \ {'mode': 'keyn'},
            \ ]

let g:nvim_tree_disable_netrw = 0
let g:nvim_tree_hijack_netrw = 0

let g:winresizer_vert_resize = 5
let g:winresizer_horiz_resize = 1

" better whitespace settings
let g:strip_whitelines_at_eof = 1
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

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
            \ }

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

let g:ale_go_golangci_lint_options = '--fast --build-tags=integration,e2e'
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
let g:ale_open_list = 0

" anything larger than 512MB is going to be ignores by syntax highlighting, events, etc.
let g:LargeFile = 512

let g:rg_derive_root='true'
let g:rg_command = 'rg --vimgrep --hidden --smart-case'

let g:undotree_WindowLayout = 4

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = "nvim_lsp"
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
            \ 'func': "\uf794 ",
            \ 'function': "\uf794 ",
            \ 'functions': "\uf794 ",
            \ 'var': "\uf71b ",
            \ 'variable': "\uf71b ",
            \ 'variables': "\uf71b ",
            \ 'const': "\uf8ff ",
            \ 'constant': "\uf8ff ",
            \ 'constructor': "\uf976 ",
            \ 'method': "\uf6a6 ",
            \ 'package': "\ue612 ",
            \ 'packages': "\ue612 ",
            \ 'enum': "\uf702 ",
            \ 'enummember': "\uf282 ",
            \ 'enumerator': "\uf702 ",
            \ 'module': "\uf136 ",
            \ 'modules': "\uf136 ",
            \ 'type': "\uf7fd ",
            \ 'typedef': "\uf7fd ",
            \ 'types': "\uf7fd ",
            \ 'field': "\uf30b ",
            \ 'fields': "\uf30b ",
            \ 'macro': "\uf8a3 ",
            \ 'macros': "\uf8a3 ",
            \ 'map': "\ufb44 ",
            \ 'class': "\uf0e8 ",
            \ 'augroup': "\ufb44 ",
            \ 'struct': "\uf318 ",
            \ 'union': "\ufacd ",
            \ 'member': "\uf02b ",
            \ 'target': "\uf893 ",
            \ 'property': "\ufab6 ",
            \ 'interface': "\uf7fe ",
            \ 'namespace': "\uf475 ",
            \ 'subroutine': "\uf9af ",
            \ 'implementation': "\uf776 ",
            \ 'typeParameter': "\uf278 ",
            \ 'default': "\uf29c ",
            \ }
let g:vista_close_on_jump = 1
let g:surround_no_insert_mappings = 1
