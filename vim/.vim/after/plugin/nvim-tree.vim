if exists(':NvimTreeToggle')
    nmap <leader>t :NvimTreeToggle<CR>
    let g:nvim_tree_width = 40
    let g:nvim_tree_ignore = [ '.git', 'node_modules']
    let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
    let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
    let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
    let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
    let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the tree. See :help nvim_tree_lsp_diagnostics
    let g:nvim_tree_icons = {
        \ 'default': '',
        \ 'symlink': '',
        \ 'git': {
        \   'unstaged': "✗",
        \   'staged': "✓",
        \   'unmerged': "",
        \   'renamed': "➜",
        \   'untracked': "★",
        \   'deleted': "",
        \   'ignored': "◌"
        \   },
        \ 'folder': {
        \   'default': "",
        \   'open': "",
        \   'empty': "",
        \   'empty_open': "",
        \   'symlink': "",
        \   'symlink_open': "",
        \   }
        \ }

"    nnoremap <leader>r :NvimTreeRefresh<CR>
"    nnoremap <leader>n :NvimTreeFindFile<CR>
    set termguicolors " this variable must be enabled for colors to be applied properly

    " a list of groups can be found at `:help nvim_tree_highlight`
    highlight NvimTreeFolderIcon guibg=blue
endif
