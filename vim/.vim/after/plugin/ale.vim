"  <Plug>(ale_previous) - ALEPrevious
"  <Plug>(ale_previous_error) - ALEPrevious -error
"  <Plug>(ale_previous_wrap_error) - ALEPrevious -wrap -error
"  <Plug>(ale_previous_warning) - ALEPrevious -warning
"  <Plug>(ale_previous_wrap_warning) - ALEPrevious -wrap -warning
"  <Plug>(ale_next) - ALENext
"  <Plug>(ale_next_error) - ALENext -error
"  <Plug>(ale_next_wrap_error) - ALENext -wrap -error
"  <Plug>(ale_next_warning) - ALENext -warning
"  <Plug>(ale_next_wrap_warning) - ALENext -wrap -warning
"  <Plug>(ale_first) - ALEFirst
"  <Plug>(ale_last) - ALELast

nmap <Leader>ll <Plug>(ale_lint)
nmap <Leader>ln <Plug>(ale_next_wrap)
nmap <Leader>lp <Plug>(ale_previous_wrap)

let g:ale_linters = {'go': ['golangci-lint', 'govet', 'golint', 'remove_trailing_lines', 'trim_whitespace']}

let g:ale_go_golangci_lint_options = '--fast'
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
highlight ALEError ctermbg=167 ctermfg=Black
highlight ALEWarning ctermbg=179 ctermfg=Black

let g:ale_sign_error = '💥'
let g:ale_sign_warning = '🔥'
let g:ale_sign_info = '💡'
