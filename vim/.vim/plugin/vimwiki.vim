let g:vimwiki_list = [
    \ {'path':'~/Dropbox/Notes',
    \ 'path_html':'~/Dropbox/Notes/html'
    \}]

if exists('g:vimwiki_addons')
  finish
endif
let g:vimwiki_addons = 1

function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>
