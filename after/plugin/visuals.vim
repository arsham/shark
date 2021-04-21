set background=dark
let g:sonokai_disable_italic_comment = 1
let g:sonokai_style = 'andromeda'
colorscheme sonokai


" remove the background of the vertical splitter
hi VertSplit ctermbg=NONE guibg=NONE
hi Visual cterm=bold ctermbg=Blue guibg=#41444F
hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
hi IncSearch guibg=#E388D5 ctermbg=green term=underline
hi VertSplit ctermfg=237 guifg=#888822
hi ExtraWhitespace ctermbg=red guibg=red
hi ColorColumn ctermbg=52 guibg=#383035


" popups
hi Pmenu guibg=#3B404D ctermbg=236 guifg=#dcdfe4 ctermfg=188


highlight ALEError ctermbg=167 ctermfg=Black
highlight ALEWarning ctermbg=179 ctermfg=Black
