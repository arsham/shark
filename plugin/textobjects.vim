onoremap <silent> i_ :<C-U>normal! T_vt_<CR>
xnoremap <silent> i_ :<C-U>normal! T_vt_<CR>
onoremap <silent> a_ :<C-U>normal! F_vf_<CR>
xnoremap <silent> a_ :<C-U>normal! F_vf_<CR>

onoremap an :call <SID>NextObj('a')<cr>
xnoremap an :call <SID>NextObj('a')<cr>
onoremap in :call <SID>NextObj('i')<cr>
xnoremap in :call <SID>NextObj('i')<cr>

function! s:NextObj(motion)
    echo
    let c = nr2char(getchar())
    exe "normal! f" . c . "v" . a:motion . c
endfunction
