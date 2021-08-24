local util = require('util')
local command = util.command

command{"Q", ':qa'}

command{"Filename",     function()
    vim.notify(vim.fn.expand '%:p', vim.lsp.log_levels.INFO, {title="Filename", timeout=3000})
end}
command{"YankFilename",  function() vim.fn.setreg('"', vim.fn.expand '%:t') end}
command{"YankFilenameC", function() vim.fn.setreg('+', vim.fn.expand '%:t') end}
command{"YankFilepath",  function() vim.fn.setreg('"', vim.fn.expand '%:p') end}
command{"YankFilepathC", function() vim.fn.setreg('+', vim.fn.expand '%:p') end}

command{"MergeConflict", ":grep '<<<<<<< HEAD'"}
command{"JsonDiff",      [[vert ball | windo execute '.!gojq' | windo diffthis]]}

command{"InstallDependencies", function()
    local commands = {
        bash       = {"npm", "-g", "install", "--prefix", "~/.node_modules", "bash-language-server@latest"},
        vim        = {"npm", "-g", "install", "--prefix", "~/.node_modules", "vim-language-server@latest"},
        dockerfile = {"npm", "-g", "install", "--prefix", "~/.node_modules", "dockerfile-language-server-nodejs@latest"},
        html       = {"npm", "-g", "install", "--prefix", "~/.node_modules", "vscode-html-languageserver-bin@latest"},
        json       = {"npm", "-g", "install", "--prefix", "~/.node_modules", "vscode-json-languageserver@latest"},
        python     = {"npm", "-g", "install", "--prefix", "~/.node_modules", "pyright@latest"},
        yaml       = {"npm", "-g", "install", "--prefix", "~/.node_modules", "yaml-language-server@latest"},
        neovim     = {"npm", "-g", "install", "--prefix", "~/.node_modules", "neovim@latest"},
        typescript = {"npm", "-g", "install", "--prefix", "~/.node_modules", "typescript@latest", "typescript-language-server@latest"},
        eslint     = {"npm", "-g", "install", "--prefix", "~/.node_modules", "eslint@latest", "--save-dev"},
        unknown    = {"npm", "-g", "install", "--prefix", "~/.node_modules", "vscode-langservers-extracted@latest"},
        sqls       = {"go", "install", "github.com/lighttiger2505/sqls@latest"},
        golangci   = {"go", "install", "github.com/nametake/golangci-lint-langserver@latest"},
        gopls      = {"go", "install", "golang.org/x/tools/gopls@latest"},
    }

    local total = table.length(commands)
    local count = 0

    local job = require('plenary.job')
    for name, spec in pairs(commands) do
        job:new({
            command = spec[1],
            args = table.slice(spec, 2, #spec),
            on_exit = function(j, exit_code)
                local res = table.concat(j:result(), "\n")
                local type = vim.lsp.log_levels.INFO
                local timeout = 3000

                if exit_code ~=0 then
                    type = vim.lsp.log_levels.ERROR
                    res = table.concat(j:stderr_result(), "\n")
                    timeout = 10000
                end

                vim.notify(res, type, {
                    title = name:title_case(),
                    timeout = timeout,
                })

                count = count + 1
                if count == total then
                    local data = "All done!\n\nPlease run:\n    yay -S ripgrep bat lua-language-server"
                    vim.notify(data, vim.lsp.log_levels.INFO, {
                        title = "Installation Process",
                        timeout = 5000,
                    })
                end
            end,
        }):start()
    end
end}
