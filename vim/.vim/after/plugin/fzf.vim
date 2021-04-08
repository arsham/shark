" Cheat sheet
"   'ctrl-t': 'tab split'
"   'ctrl-x': 'split'
"   'ctrl-v': 'vsplit'
if ! exists(':FZF')
    finish
endif

set rtp+=~/.fzf
nnoremap <silent> <C-p> :Files<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <silent> <leader>f :ArshamRg<CR>

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
" https://github.com/junegunn/fzf.vim/issues/162
let g:fzf_commands_expect = 'enter'
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
let g:fzf_buffers_jump = 1          " [Buffers] Jump to the existing window if possible
let g:fzf_preview_window = ['right:50%', 'ctrl-/']


" let $FZF_DEFAULT_OPTS = '--preview "bat --color=always --style=numbers --line-range=:500 {}"'

command! -bang -nargs=* ArshamRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


" command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

" see if this one is any good
" command! -bang -nargs=? Marks
    \ call fzf#vim#marks({'options': ['--preview', 'cat -n {-1} | egrep --color=always -C 10 ^[[:space:]]*{2}[[:space:]]']})


" ctrl+p -> @ and : implementation like sublime
function! s:goto_def(lines) abort
  silent! exe 'e +BTags '.a:lines[0]
  call timer_start(10, {-> execute('startinsert') })
endfunction
function! s:goto_line(lines) abort
  silent! exe 'e '.a:lines[0]
  call timer_start(10, {-> feedkeys(':') })
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ '@': function('s:goto_def'),
  \ ':': function('s:goto_line')
  \  }

""""""""""""""
" Experimental :Outline
function! s:outline_format(lists)
  for list in a:lists
    let linenr = list[2][:len(list[2])-3]
    let line = getline(linenr)
    let idx = stridx(line, list[0])
    let len = len(list[0])
    let list[0] = line[:idx-1] . printf("\x1b[%s%sm%s\x1b[m", 34, '', line[idx:idx+len-1]) . line[idx+len:]
  endfor
  for list in a:lists
    call map(list, "printf('%s', v:val)")
  endfor
  return a:lists
endfunction

function! s:outline_source(tag_cmds)
  if !filereadable(expand('%'))
    throw 'Save the file first'
  endif

  for cmd in a:tag_cmds
    let lines = split(system(cmd), "\n")
    if !v:shell_error
      break
    endif
  endfor
  if v:shell_error
    throw get(lines, 0, 'Failed to extract tags')
  elseif empty(lines)
    throw 'No tags found'
  endif
  return map(s:outline_format(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
endfunction

function! s:outline_sink(lines)
  if !empty(a:lines)
    let line = a:lines[0]
    execute split(line, "\t")[2]
  endif
endfunction

function! s:outline(...)
  let args = copy(a:000)
  let tag_cmds = [
    \ printf('ctags -f - --sort=no --excmd=number --language-force=%s %s 2>/dev/null', &filetype, expand('%:S')),
    \ printf('ctags -f - --sort=no --excmd=number %s 2>/dev/null', expand('%:S'))]
  return {
    \ 'source':  s:outline_source(tag_cmds),
    \ 'sink*':   function('s:outline_sink'),
    \ 'options': '--reverse +m -d "\t" --with-nth 1 -n 1 --ansi --prompt "Outline> "'}
endfunction

command! -bang Outline call fzf#run(fzf#wrap('outline', s:outline(), <bang>0))
