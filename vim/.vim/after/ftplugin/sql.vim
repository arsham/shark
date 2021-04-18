if exists("b:sql_plugin")
    finish
endif
let b:sql_plugin = 1

if exists('<Plug>SQLUFormatter')
    augroup SQLFORMATTER
        autocmd!
        autocmd FileType sql xmap <buffer> = <Plug>SQLUFormatter
        autocmd FileType sql nmap <buffer> = <Plug>SQLUFormatter
    augroup END
endif
