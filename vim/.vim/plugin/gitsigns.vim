lua << EOF
require('gitsigns').setup {
    signs = {
      add = {text = '▋'},
      change = {text= '▋'},
      delete = {text = '▋'},
      topdelete = {text = '▔'},
      changedelete = {text = '▎'},
    },
}
EOF

" hi GitGutterAdd ctermfg=107 guifg=#9ed072
" hi SignifySignAdd ctermfg=107 guifg=#9ed072
" hi DiffAdd ctermfg=107 guifg=#9ed072

" hi GitGutterChange ctermfg=110 guifg=#76cce0
" hi SignifySignChange ctermfg=110 guifg=#76cce0
" hi DiffChange ctermfg=110 guifg=#76cce0

" hi GitGutterDelete ctermfg=203 guifg=#fc5d7c
" hi SignifySignDelete ctermfg=203 guifg=#fc5d7c
" hi DiffDelete ctermfg=203 guifg=#fc5d7c
