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

command! -bang -nargs=* ArshamRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.local/share/nvim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

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
