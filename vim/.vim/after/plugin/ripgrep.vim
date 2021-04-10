if executable('rg')
    let g:rg_derive_root='true'
    let g:rg_command = 'rg --vimgrep --hidden --smart-case'
endif
