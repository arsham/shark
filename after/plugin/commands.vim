command! Callers         execute "lua vim.lsp.buf.incoming_calls()"
command! Callees         execute "lua vim.lsp.buf.outgoing_calls()"
command! References      execute "lua vim.lsp.buf.references()"
command! Rename          execute "lua vim.lsp.buf.rename()"
command! Implementation  execute "lua vim.lsp.buf.implementation()"
command! AddWorkspace    execute "lua vim.lsp.buf.add_workspace_folder()"
command! RemoveWorkspace execute "lua vim.lsp.buf.remove_workspace_folder()"
command! ListWorkspace   execute "lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"
command! CodeAction      execute "lua vim.lsp.buf.code_action()"
command! TypeDefinition  execute "lua vim.lsp.buf.type_definition()"
command! Definition      execute "lua vim.lsp.buf.definition()"

command! Reload          execute "source $MYVIMRC"
command! Filename        execute ":echo expand('%:p')"
command! Config          execute ":e $MYVIMRC"
command! Todo    silent! execute "grep todo|fixme **/*" | copen

command! YankFilename    let @"=expand("%:t")
command! YankFilepath    let @"=expand("%:p")
command! MergeConflict   :grep "<<<<<<< HEAD"
command! -bang Notes     call fzf#vim#files('~/Dropbox/Notes', <bang>0)
command! -nargs=1 -bang Locate call fzf#run(fzf#wrap({'source': 'locate <q-args>', 'options': '-m'}, <bang>0))

" Insert lorem ipsum.
command! LoremLines call s:lorem_line()
function! s:lorem_line()
    let l:len = input("How many lines? ")
    execute ".!lorem -l ".l:len
endfunction

function! s:install_dependencies() abort
    execute "!npm -g install --prefix ~/.node_modules bash-language-server@latest"
    execute "!npm -g install --prefix ~/.node_modules vim-language-server@latest"
    execute "!npm -g install --prefix ~/.node_modules dockerfile-language-server-nodejs@latest"
    execute "!npm -g install --prefix ~/.node_modules vscode-html-languageserver-bin@latest"
    execute "!npm -g install --prefix ~/.node_modules vscode-json-languageserver@latest"
    execute "!npm -g install --prefix ~/.node_modules pyright@latest"
    execute "!npm -g install --prefix ~/.node_modules yaml-language-server@latest"
    execute "!npm -g install --prefix ~/.node_modules neovim@latest"
    execute "!go install github.com/lighttiger2505/sqls@latest"
    execute "!go install github.com/nametake/golangci-lint-langserver@latest"
    execute "!go install golang.org/x/tools/gopls@latest"
    echo "Please run: yay -S lua-language-server-git"
endfunction
command! InstallDependencies :call <SID>install_dependencies()<CR>

" This is an example how the increment function could have been implemented.
" accepts a count, so that we can type 3<C-a> to add three to the next number.
" This is not something we could do with the :call version.
" function! Increment() abort
"     call search('\d\@<!\d\+\%#\d', 'b')
"     call search('\d', 'c')
"     norm! v
"     call search('\d\+', 'ce')
"     exe "norm!" "\<C-a>"
"     return ''
" endfun
"nnoremap <silent> <C-a> @=Increment()<cr>

" Show all files in the cwd in fzf UI.
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, {'options': [
            \ '--layout=reverse',
            \ '--info=inline',
            \ '--preview',
            \ '~/.local/share/nvim/plugged/fzf.vim/bin/preview.sh {}'
            \ ]}, <bang>0)

function! s:list_buffers()
    redir => list
    silent ls
    redir END
    return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
    execute 'bd ' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

" Delete buffers interactivly with fzf.
command! BDelete call fzf#run(fzf#wrap({
            \ 'source': s:list_buffers(),
            \ 'sink*': { lines -> s:delete_buffers(lines) },
            \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
            \ }))
command! BufDelete BDelete

function! s:delete_args(lines)
    execute 'argd ' join(a:lines)
endfunction

" Delete args interactivly with fzf.
command! ArgsDelete call fzf#run(fzf#wrap({
            \ 'source': argv(),
            \ 'sink*': { lines -> s:delete_args(lines) },
            \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
            \ }))
command! ArgDelete ArgsDelete
