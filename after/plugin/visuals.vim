set background=dark

func! OverrideHighlights() abort
    hi Normal ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi EndOfBuffer ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi SignColumn ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi Tabline ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi TablineFill ctermfg=250 ctermbg=235 guifg=#e1e3e4 guibg=#232627
    hi BlueSign ctermfg=110 ctermbg=236 guifg=#6dcae8 guibg=#232627
    hi GreenSign ctermfg=107 ctermbg=236 guifg=#9ed06c guibg=#232627
    hi RedSign ctermfg=203 ctermbg=236 guifg=#fb617e guibg=#232627

    " remove the background of the vertical splitter
    hi VertSplit ctermbg=NONE guibg=NONE
    hi Visual cterm=bold ctermbg=Blue guibg=#41444F
    hi Search ctermfg=236 ctermbg=180 guifg=#282c34 guibg=#5992F0 gui=italic,underline,bold
    hi IncSearch guibg=#E388D5 ctermbg=green term=underline
    hi VertSplit ctermfg=237 guifg=#888822
    hi ExtraWhitespace ctermbg=red guibg=red
    hi ColorColumn ctermbg=52 guibg=#2E2A2A

    " popups
    hi Pmenu guibg=#3B404D ctermbg=236 guifg=#dcdfe4 ctermfg=188

    hi ALEError ctermbg=167 ctermfg=Black
    hi ALEWarning ctermbg=179 ctermfg=Black

    " Terminal colours.
    unlet g:terminal_color_0
    unlet g:terminal_color_1
    unlet g:terminal_color_2
    unlet g:terminal_color_3
    unlet g:terminal_color_4
    unlet g:terminal_color_5
    unlet g:terminal_color_6
    unlet g:terminal_color_7
    unlet g:terminal_color_8
    unlet g:terminal_color_9
    unlet g:terminal_color_10
    unlet g:terminal_color_11
    unlet g:terminal_color_12
    unlet g:terminal_color_13
    unlet g:terminal_color_14
    unlet g:terminal_color_15
endfunction

augroup OverrideSonokaiColors
    autocmd!
    autocmd ColorScheme sonokai call OverrideHighlights()
augroup END

let g:sonokai_disable_italic_comment = 1
let g:sonokai_style = 'andromeda'
colorscheme sonokai

set guifont=DejaVuSansMono\ Nerd\ Font:h10
