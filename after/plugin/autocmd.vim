" Make Sure that Vim returns to the same line when we reopen a file"
augroup LINE_RETURN
    autocmd! * <buffer>
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \ execute 'normal! g`"zvzz' |
                \ endif
augroup END

augroup FILETYPE_COMMANDS
    autocmd! * <buffer>
    " autocmd BufNewFile,BufRead *.mkd,*.md,*.markdown setfiletype markdown
    " autocmd BufNewFile,BufRead *.json setfiletype javascript
    autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd Filetype make,automake setlocal noexpandtab
    autocmd Filetype markdown setlocal spell
    autocmd Filetype gitcommit setlocal spell textwidth=76 colorcolumn=77
    autocmd BufNewFile,BufRead .*aliases set ft=sh

    " Ensure tabs don't get converted to spaces in Makefiles.
    autocmd FileType make setlocal noexpandtab

    " highlight yanking
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()

    " resize Split When the window is resized
    au VimResized * :wincmd =
    " autocmd Filetype go <buffer> command! Goimports execute "!goimports -w %"
augroup END

" For now we are testing the whitespace plugin.
" augroup TRAILING_SPACES
"     autocmd!
"     " Auto remove trailing spaces
"     autocmd BufWritePre * silent! :%s/\s\+$//e
" augroup END

augroup AUTO_NUMBERS
    autocmd!
    autocmd WinEnter * set relativenumber
    autocmd WinLeave * set norelativenumber
augroup END

" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave * silent! mkview
"   autocmd BufWinEnter * silent! loadview
" augroup END
