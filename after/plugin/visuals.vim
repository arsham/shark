set background=dark

autocmd ColorScheme sonokai hi Normal ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi EndOfBuffer ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi SignColumn ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi Tabline ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi TablineFill ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
autocmd ColorScheme sonokai hi BlueSign ctermfg=110 ctermbg=236 guifg=#6dcae8 guibg=#232627
autocmd ColorScheme sonokai hi GreenSign ctermfg=107 ctermbg=236 guifg=#9ed06c guibg=#232627
autocmd ColorScheme sonokai hi RedSign ctermfg=203 ctermbg=236 guifg=#fb617e guibg=#232627

" remove the background of the vertical splitter
autocmd ColorScheme sonokai hi VertSplit ctermbg=NONE guibg=NONE
autocmd ColorScheme sonokai hi Visual cterm=bold ctermbg=Blue guibg=#41444F
autocmd ColorScheme sonokai hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
autocmd ColorScheme sonokai hi IncSearch guibg=#E388D5 ctermbg=green term=underline
autocmd ColorScheme sonokai hi VertSplit ctermfg=237 guifg=#888822
autocmd ColorScheme sonokai hi ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme sonokai hi ColorColumn ctermbg=52 guibg=#383035

" popups
autocmd ColorScheme sonokai hi Pmenu guibg=#3B404D ctermbg=236 guifg=#dcdfe4 ctermfg=188

autocmd ColorScheme sonokai hi ALEError ctermbg=167 ctermfg=Black
autocmd ColorScheme sonokai hi ALEWarning ctermbg=179 ctermfg=Black

" Terminal colours.
autocmd ColorScheme sonokai unlet g:terminal_color_0
autocmd ColorScheme sonokai unlet g:terminal_color_1
autocmd ColorScheme sonokai unlet g:terminal_color_2
autocmd ColorScheme sonokai unlet g:terminal_color_3
autocmd ColorScheme sonokai unlet g:terminal_color_4
autocmd ColorScheme sonokai unlet g:terminal_color_5
autocmd ColorScheme sonokai unlet g:terminal_color_6
autocmd ColorScheme sonokai unlet g:terminal_color_7
autocmd ColorScheme sonokai unlet g:terminal_color_8
autocmd ColorScheme sonokai unlet g:terminal_color_9
autocmd ColorScheme sonokai unlet g:terminal_color_10
autocmd ColorScheme sonokai unlet g:terminal_color_11
autocmd ColorScheme sonokai unlet g:terminal_color_12
autocmd ColorScheme sonokai unlet g:terminal_color_13
autocmd ColorScheme sonokai unlet g:terminal_color_14
autocmd ColorScheme sonokai unlet g:terminal_color_15

let g:sonokai_disable_italic_comment = 1
let g:sonokai_style = 'andromeda'
colorscheme sonokai
