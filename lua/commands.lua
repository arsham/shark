local util = require('util')
local command = util.command
local M = {}


command("Filename", function()
    vim.notify(vim.fn.expand '%:p', vim.lsp.log_levels.INFO, {title="Filename", timeout=3000})
end)
command("YankFilename",  function() vim.fn.setreg('"', vim.fn.expand '%:t') end)
command("YankFilenameC", function() vim.fn.setreg('+', vim.fn.expand '%:t') end)
command("YankFilepath",  function() vim.fn.setreg('"', vim.fn.expand '%:p') end)
command("YankFilepathC", function() vim.fn.setreg('+', vim.fn.expand '%:p') end)

command("MergeConflict", ":grep '<<<<<<< HEAD'")
command("JsonDiff",      [[vert ball | windo execute '%!gojq' | windo diffthis]])

---Sets up a watch on the filename if it is a lua module.
---@param filenames string[]
local function setup_watch(filenames)
    local modules = {}
    for _, filename in ipairs(filenames) do
        local mod, ok = util.file_module(filename)

        if not ok then
            local msg = string.format('Could not figure out the package: %s', filename)
            vim.notify(msg, vim.lsp.log_levels.ERROR, {
                title = 'Reload Error',
                timeout = 2000,
            })
        else
            table.insert(modules, mod)
        end
    end
    return modules
end

function M.watch_file_changes(filenames)
    local modules= setup_watch(filenames)
    local names = {}
    for _, module in ipairs(modules) do
        table.insert(names, module.name)
        util.autocmd{"WATCH_LUA_FILE BufWritePost", module.name, run=function()
            for _, mod in ipairs(modules) do
                package.loaded[mod.module] = nil
                require(mod.module)
            end
            local msg = table.concat(names, "\n")
            vim.notify(msg, vim.lsp.log_levels.INFO, {
                title   = 'Reloaded',
                timeout = 1000,
            })
        end, docs=string.format('watching %s', module.name)}
    end
    local msg = table.concat(names, "\n")
    vim.notify(msg, vim.lsp.log_levels.INFO, {
        title   = 'Watching Changes',
        timeout = 2000,
    })
end

util.augroup{"WATCH_LUA_FILE"}
command("WatchLuaFileChanges", function(arg)
    local filename = vim.fn.expand('%:p')
    local files = arg and arg:split() or {}
    table.insert(files, filename)
    M.watch_file_changes(files)
end, {nargs='*', complete='file'})

command("CC", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end)

command("FoldComments", function()
    vim.wo.foldexpr=[[getline(v:lnum)=~'^\s*//']]
    vim.wo.foldmethod="expr"
end)

util.buffer_command("Nowrap", function()
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    vim.bo.formatoptions = vim.bo.formatoptions:gsub('c', '')
end)

command("InstallDependencies", function()
    local commands = _t{
        golangci   = _t{"go", "install", "github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0"},
        gojq       = _t{"go", "install", "github.com/itchyny/gojq/cmd/gojq@latest"},
        fixjson    = _t{"npm", "-g", "install", "--prefix", "~/.node_modules", "fixjson@latest"},
        prettier   = _t{"npm", "-g", "install", "--prefix", "~/.node_modules", "prettier@latest"},
        neovim     = _t{"npm", "-g", "install", "--prefix", "~/.node_modules", "neovim@latest"},
    }

    local total = commands:length()
    local count = 0

    local job = require('plenary.job')
    for name, spec in pairs(commands) do
        job:new({
            command = spec[1],
            args = spec:slice(2, #spec),
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
                    local str =  "yay -S ripgrep bat ccls words-insane ctags python-pip the_silver_searcher && snap install diagon"
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
end)

return M
