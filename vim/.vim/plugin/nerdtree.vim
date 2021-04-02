" Cheatsheet
" o: open in prev window
" go: preview
" t: open in new tab
" T: open in new tab silently
" i: open split
" gi: preview split
" s: open vsplit
" gs: preview vsplit


nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-k><C-b> :NERDTreeToggle<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>                  " open the tree on current file

" Exit Vim if NERDTree is the only window left.
augroup NERDTREE_ENTER
    autocmd!
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
                \ quit | endif
augroup END


let NERDTreeHijackNetrw=1
let NERDTreeShowHidden=1
let g:NERDTreeWinSize=38
let g:NERDSpaceDelims = 1
let g:NERDTreeGitStatusUseNerdFonts = 1

function! ToggleNERDTree()
  NERDTreeToggle
  silent NERDTreeMirror
endfunction

nmap <leader>n :call ToggleNERDTree()<CR>
