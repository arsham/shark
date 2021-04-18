command! Reload execute "source $MYVIMRC"
command! Filename execute ":echo expand('%:p')"
command! Config execute ":e $MYVIMRC"
command! -bang Notes call fzf#vim#files('~/Dropbox/Notes', <bang>0)
command! -nargs=1 -bang Locate call fzf#run(fzf#wrap({'source': 'locate <q-args>', 'options': '-m'}, <bang>0))

" This is an example how the increment function could have been implemented.
" accepts a count, so that we can type 3<C-a> to add three to the next number.
" This is not something we could do with the :call version.
" function! Increment() abort
"     call search('\d\@<!\d\+\%#\d', 'b')
"     call search('\d', 'c')
"     norm! v
"     call search('\d\+', 'ce')
"     exe "norm!" "\<C-a>"
"     return ''
" endfun

"nnoremap <silent> <C-a> @=Increment()<cr>



" Add all TODO items to the quickfix list relative to where you opened Vim.
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -niIw -e TODO -e FIXME 2> /dev/null',
                \ 'grep -rniIw -e TODO -e FIXME . 2> /dev/null']
        let lines = split(system(cmd), '\n')
        if v:shell_error != 0 | continue | endif
        for line in lines
            let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
            call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
    endfor

    if !empty(entries)
        call setqflist(entries)
        copen
    endif
endfunction

command! Todo call s:todo()
