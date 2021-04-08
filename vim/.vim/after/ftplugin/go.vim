augroup VIMGO
    autocmd!
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go setlocal noexpandtab
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

augroup VIMGO_MAPS
    autocmd FileType go inoremap <buffer> <tab> <C-x><C-o>
    autocmd FileType go nnoremap <buffer> gd :GoDef<cr>
    autocmd FileType go nnoremap <buffer> gb :GoDefPop<cr>
    " go to the implementation of an interface call (ctrl-h)
    autocmd FileType go nnoremap <buffer> gimpl :GoImplements<cr>
    autocmd FileType go nnoremap <buffer> <C-h> :GoImplements<cr>
    autocmd FileType go nnoremap <buffer> gref :GoReferrers<cr>
augroup END
