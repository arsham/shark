augroup SQLFORMATTER
    autocmd!
    autocmd FileType sql vmap = <Plug>SQLUFormatter
    autocmd FileType sql nmap = <Plug>SQLUFormatter
augroup END

let g:sqh_provider = 'psql'
