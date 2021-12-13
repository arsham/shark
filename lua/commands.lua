local util = require('util')
local command = util.command

command{"Filename", function()
    vim.notify(vim.fn.expand '%:p', vim.lsp.log_levels.INFO, {title="Filename", timeout=3000})
end}
command{"YankFilename",  function() vim.fn.setreg('"', vim.fn.expand '%:t') end}
command{"YankFilenameC", function() vim.fn.setreg('+', vim.fn.expand '%:t') end}
command{"YankFilepath",  function() vim.fn.setreg('"', vim.fn.expand '%:p') end}
command{"YankFilepathC", function() vim.fn.setreg('+', vim.fn.expand '%:p') end}

command{"MergeConflict", ":grep '<<<<<<< HEAD'"}
command{"JsonDiff",      [[vert ball | windo execute '%!gojq' | windo diffthis]]}

command{"WatchLuaFileChanges", docs="watch changes on the lua file and reload", run=function()
    util.augroup{"WATCH_LUA_FILE", {
        {"BufWritePost", buffer=true, run=function()
            vim.cmd[[:luafile %]]
        end},
    }}
end}

command{"CC", docs="close all floating windows", run=function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end}

command{"Scratch", docs="open a new scratch buffer", run=function()
    vim.api.nvim_command("silent! new")
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false
end}

command{"InstallDependencies", function()
    local commands = {
        golangci   = {"go", "install", "github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0"},
        gojq       = {"go", "install", "github.com/itchyny/gojq/cmd/gojq@latest"},
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
                local timeout = 2000

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
                    local str =  "yay -S ripgrep bat ccls words-insane ctags"
                    vim.schedule(function()
                        vim.fn.setreg('+', str)
                    end)
                    local data = table.concat({
                        "Please run:",
                        "    " .. str,
                        "",
                        "The command has been yanked to your clickboard!",
                    }, "\n")
                    vim.notify(data, vim.lsp.log_levels.INFO, {
                        title = "All done!",
                        timeout = 3000,
                    })
                end
            end,
        }):start()
    end
end}
