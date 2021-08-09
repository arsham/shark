set rtp+=~/.fzf
" ctrl+p -> @, : and / to go to symbols, line and or search in lines.
function! s:goto_def(lines) abort
    silent! exe 'e +BTags '.a:lines[0]
    call timer_start(10, {-> execute('startinsert') })
endfunction
function! s:goto_line(lines) abort
    silent! exe 'e '.a:lines[0]
    call timer_start(10, {-> feedkeys(':') })
endfunction
function! s:search_file(lines) abort
    silent! exe 'e +Lines '.a:lines[0]
    call timer_start(10, {-> execute('startinsert') })
endfunction


let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit',
            \ '@': function('s:goto_def'),
            \ ':': function('s:goto_line'),
            \ '/': function('s:search_file')
            \ }
