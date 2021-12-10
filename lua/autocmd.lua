local util = require('util')
require('astronauta.keymap')

util.augroup{"LINE_RETURN", {
    {"BufReadPost", "*", function()
        local line = vim.fn.line
        if line("'\"") > 0 and line("'\"") <= line("$") then
            vim.cmd[[normal! g`"zvzz']]
        end
    end},
}}

util.augroup{"SPECIAL_SETTINGS", {
    {"VimResized", "*", docs="resize split on window resize", run=":wincmd ="},

    {"BufRead", "*", docs="large file enhancements", run=function()
        if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
            return
        end

        local lines = vim.api.nvim_buf_line_count(0)
        if lines > 20000 then

            local undofile       = vim.bo.undofile
            local colorcolumn    = vim.wo.colorcolumn
            local relativenumber = vim.wo.relativenumber
            local hlsearch       = vim.opt.hlsearch
            local lazyredraw     = vim.opt.lazyredraw
            local showmatch      = vim.opt.showmatch

            vim.bo.undofile       = false
            vim.wo.colorcolumn    = ""
            vim.wo.relativenumber = false
            vim.opt.hlsearch      = false
            vim.opt.lazyredraw    = true
            vim.opt.showmatch     = false

            util.autocmd{"BufDelete", buffer=true, run=function()
                vim.bo.undofile       = undofile
                vim.wo.colorcolumn    = colorcolumn
                vim.wo.relativenumber = relativenumber
                vim.opt.hlsearch      = hlsearch
                vim.opt.lazyredraw    = lazyredraw
                vim.opt.showmatch     = showmatch

                vim.notify("Settings Restored", vim.lsp.log_levels.INFO, {
                    title = "Settings Change",
                    timeout = 4000,
                })
            end}

            local message = "File was too large, had to disable some settings!"
            vim.notify(message, vim.lsp.log_levels.WARN, {
                title = "Settings Change",
                timeout = 4000,
            })
        end
    end},

    {"BufWritePre", "COMMIT_EDITMSG,MERGE_MSG,gitcommit,*.tmp,*.log", function()
        vim.bo.undofile = false
    end},

    {"Filetype", "gitcommit", docs="commit messages", run=function()
        -- see #14670
        -- vim.bo.textwidth = 72
        -- vim.wo.colorcolumn = "50,72"
        -- vim.wo.spell = true
        vim.cmd[[ setlocal spell ]]
        vim.cmd[[ setlocal textwidth=72 ]]
        vim.cmd[[ setlocal colorcolumn="50,72" ]]
    end},
}}


local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
    util.augroup{"FILETYPE_COMMANDS", {
        {events="Filetype", targets="python,proto", run=function()
            vim.bo.tabstop = 4
            vim.bo.softtabstop = 4
            vim.bo.shiftwidth = 4
        end},

        {"Filetype", "make,automake", docs="makefile tabs", run=function()
            vim.bo.expandtab = false
        end},

        {"Filetype", "markdown", docs="spell checker", run=function()
            -- see #14670
            -- vim.opt_local.spell = true
            vim.cmd[[ setlocal spell ]]
        end},

        {"BufNewFile,BufRead", ".*aliases", run=function() vim.bo.filetype = 'sh' end},

        {"TextYankPost", "*", docs="highlihgt yanking", run=function()
            vim.highlight.on_yank{ higroup = "Substitute", timeout = 150 }
        end},

        -- auto reload file if changed, need the following two
        -- reload files changed outside vim
        -- {events="FileChangedShell", targets="*", run='echo "Warning: File changed on disk"'},
        -- au FocusGained,BufEnter * : checktime

        {"BufRead,BufNewFile", "*", docs="signcolumn sizes", run=function()
            vim.wo.signcolumn = 'auto:2'
        end},

        {"Filetype", "json", run=function()
            vim.bo.softtabstop = 2
            vim.bo.tabstop = 4
        end},

        {"Filetype", "sql", docs="don't wrap me", run=function()
            vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
        end},
    }}

    util.augroup{"TRIM_WHITE_SPACES", {
        {"BufWritePre,FileWritePre,FileAppendPre,FilterWritePre", "*",
            docs="trim spaces",
            run=function()
                if not vim.bo.modifiable or vim.bo.binary or vim.bo.filetype == 'diff' then
                    return
                end
                local save = vim.fn.winsaveview()
                vim.cmd[[ keeppatterns %s/\s\+$//e ]]
                vim.cmd[[silent! %s#\($\n\s*\)\+\%$##]]
                vim.fn.winrestview(save)
            end,
        }
    }}
    async_load_plugin:close()
end))
async_load_plugin:send()
