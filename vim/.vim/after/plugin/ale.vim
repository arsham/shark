if ! exists(':ALEInfo')
    finish
endif
nmap <Leader>lp <Plug>(ale_previous_wrap)
nmap <Leader>ln <Plug>(ale_next_wrap)
nmap <Leader>ll <Plug>(ale_lint)


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
highlight ALEError ctermbg=167 ctermfg=Black
highlight ALEWarning ctermbg=179 ctermfg=Black

let g:ale_sign_error = '💣'
let g:ale_sign_warning = '❗'
let g:ale_sign_info = 'ℹ️'
