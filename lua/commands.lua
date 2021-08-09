local command = require('util').command

command{"Callees",          vim.lsp.buf.outgoing_calls}
command{"Callers",          vim.lsp.buf.incoming_calls}
command{"References",       vim.lsp.buf.references}
command{"Rename",           vim.lsp.buf.rename}
command{"Implementation",   vim.lsp.buf.implementation}
command{"AddWorkspace",     vim.lsp.buf.add_workspace_folder}
command{"RemoveWorkspace",  vim.lsp.buf.remove_workspace_folder}
command{"ListWorkspace",    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end}
command{"CodeAction",       vim.lsp.buf.code_action}
command{"TypeDefinition",   vim.lsp.buf.type_definition}
command{"Definition",       vim.lsp.buf.definition}
command{"DocumentSymbols",  vim.lsp.buf.document_symbol}
command{"WorkspaceSymbols", vim.lsp.buf.workspace_symbol}
command{"Diagnostics",      function() require('lspfuzzy').diagnostics(0) end}
command{"DiagnosticsAll",   "LspDiagnosticsAll"}

command{"Todo",             "grep todo|fixme **/*", post_run="cw", silent=true}
command{"Filename",         function() print(vim.fn.expand '%:p') end}
command{"YankFilename",     function() vim.fn.setreg('"', vim.fn.expand '%:t') end}
command{"YankFilepath",     function() vim.fn.setreg('"', vim.fn.expand '%:p') end}
command{"Notes",            "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", attrs="-bang"}
command{"Dotfiles",         "call fzf#vim#files('~/dotfiles/', <bang>0)", attrs="-bang"}

command{"Reload",           "luafile $MYVIMRC"}
command{"Config",           ":e $MYVIMRC"}
command{"MergeConflict",    ":grep '<<<<<<< HEAD'"}
command{"JsonDiff",         [[vert ball | windo execute '.!gojq' | windo diffthis]]}

local function install_dependencies()
    print(vim.fn.system("npm -g install --prefix ~/.node_modules bash-language-server@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules vim-language-server@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules dockerfile-language-server-nodejs@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules vscode-html-languageserver-bin@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules vscode-json-languageserver@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules pyright@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules yaml-language-server@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules neovim@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules typescript@latest typescript-language-server@latest"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules eslint@latest --save-dev"))
    print(vim.fn.system("npm -g install --prefix ~/.node_modules vscode-langservers-extracted@latest"))
    print(vim.fn.system("go install github.com/lighttiger2505/sqls@latest"))
    print(vim.fn.system("go install github.com/nametake/golangci-lint-langserver@latest"))
    print(vim.fn.system("go install golang.org/x/tools/gopls@latest"))
    print("Please run: yay -S lua-language-server")
end
command{"InstallDependencies", install_dependencies}


function List_buffers()
    local buffers = vim.api.nvim_list_bufs()
    local names = {}
    for _, h in pairs(buffers) do
        table.insert(names, vim.api.nvim_buf_get_name(h))
    end
    return names
end

function Delete_buffers(names)
    for _, name in pairs(names) do
        vim.api.nvim_buf_delete(name, {})
    end
end

-- Delete buffers interactivly with fzf.
command{"BDelete", function()
    local t = {
        "call fzf#run(fzf#wrap({",
        "     'source': v:lua.List_buffers(),",
        "     'sink*': { lines -> v:lua.Delete_buffers(lines) },",
        "     'options': '--multi --reverse --bind ctrl-a:select-all+accept'",
        "     }))",
        }
        vim.cmd(table.concat(t, " "))
    end
}
command{"BufDelete", "BDelete"}

local t = {
    "command! -bang -nargs=* GGrep ",
    " call fzf#vim#grep(",
    [[   'git grep --line-number -- '.shellescape(<q-args>), 0,]],
    "   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)",
}
vim.cmd(table.concat(t, " "))

function Delete_args(lines)
    vim.cmd('argd ' .. table.concat(lines, " "))
end

-- Delete args interactivly with fzf.
command{"ArgsDelete", function()
    local t = {
        "call fzf#run(fzf#wrap({",
        "     'source': argv(),",
        "     'sink*': { lines -> v:lua.Delete_args(lines) },",
        "     'options': '--multi --reverse --bind ctrl-a:select-all+accept'",
        "     }))",
        }
        vim.cmd(table.concat(t, " "))
    end
}
command{"ArgDelete", "ArgsDelete"}
