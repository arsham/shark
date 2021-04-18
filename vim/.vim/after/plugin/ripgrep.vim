if ! executable('rg')
    finish
endif
let g:rg_derive_root='true'
let g:rg_command = 'rg --vimgrep --hidden --smart-case'
" This is here as a reference. You don't need it. Just execute :Rg without any
" input!
nnoremap <silent> <leader>rg :Rg <C-R>=expand("<cword>")<CR><CR>
