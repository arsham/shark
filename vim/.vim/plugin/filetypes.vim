autocmd BufNewFile,BufRead .*aliases set ft=sh         " also has syntax=sh but it's useless here

" Ensure tabs don't get converted to spaces in Makefiles.
autocmd FileType make setlocal noexpandtab
