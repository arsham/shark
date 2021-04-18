" hi! link goSameId SpecialArsham
" highlight SpecialArsham ctermbg=167 ctermfg=Black

autocmd Filetype go command! Goimports execute "!goimports -w %"
