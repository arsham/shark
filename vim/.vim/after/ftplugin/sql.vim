augroup SQLFORMATTER
    autocmd!
    autocmd FileType sql xmap <buffer> = <Plug>SQLUFormatter
    autocmd FileType sql nmap <buffer> = <Plug>SQLUFormatter
augroup END
