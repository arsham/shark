onoremap an :call <SID>NextObj('a')<cr>
xnoremap an :call <SID>NextObj('a')<cr>
onoremap in :call <SID>NextObj('i')<cr>
xnoremap in :call <SID>NextObj('i')<cr>

function! s:NextObj(motion)
    echo
    let c = nr2char(getchar())
    exe "normal! f" . c . "v" . a:motion . c
endfunction

" onoremap <silent> i_ :<C-U>normal! T_vt_<CR>
" xnoremap <silent> i_ :<C-U>normal! T_vt_<CR>
" onoremap <silent> a_ :<C-U>normal! F_vf_<CR>
" xnoremap <silent> a_ :<C-U>normal! F_vf_<CR>

" Copied from https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
	execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
	execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
	execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" Number pseudo-text object (integer and float)
" Exmaple: ciN
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap iN :<C-u>call VisualNumber()<CR>
onoremap iN :<C-u>normal vin<CR>
