command! Callers execute "lua vim.lsp.buf.incoming_calls()"
command! References execute "lua vim.lsp.buf.references()"
command! Rename execute "lua vim.lsp.buf.rename()"
command! Implementation execute "lua vim.lsp.buf.implementation()"

command! Resize execute ":WinResizerStartResize"
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

command! -bang -nargs=* ArshamRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.local/share/nvim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)


function! s:list_buffers()
    redir => list
    silent ls
    redir END
    return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
    execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
            \ 'source': s:list_buffers(),
            \ 'sink*': { lines -> s:delete_buffers(lines) },
            \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
            \ }))
