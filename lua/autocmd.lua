local util = require('util')

util.augroup{"LINE_RETURN", {
    {"BufReadPost", "*", function()
        local line = vim.fn.line
        if line("'\"") > 0 and line("'\"") <= line("$") and vim.bo.buftype ~= 'nofile' then
            vim.cmd[[normal! g`"zv']]
        end
    end},
}}

util.augroup{"SPECIAL_SETTINGS", {
    {"VimResized", "*", docs="resize split on window resize", run=":wincmd ="},

    {"BufRead", "*", docs="large file enhancements", run=function()
        if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
            return
        end

        local size = vim.fn.getfsize(vim.fn.expand('%'))
        if size > 1024 * 1024 * 5 then
            local hlsearch       = vim.opt.hlsearch
            local lazyredraw     = vim.opt.lazyredraw
            local showmatch      = vim.opt.showmatch

            vim.bo.undofile       = false
            vim.wo.colorcolumn    = ''
            vim.wo.relativenumber = false
            vim.wo.foldmethod     = 'manual'
            vim.wo.spell          = false
            vim.opt.hlsearch      = false
            vim.opt.lazyredraw    = true
            vim.opt.showmatch     = false

            util.autocmd{"BufDelete", buffer=true, run=function()
                vim.opt.hlsearch      = hlsearch
                vim.opt.lazyredraw    = lazyredraw
                vim.opt.showmatch     = showmatch
            end}
        end
    end},

    {"BufWritePre", "COMMIT_EDITMSG,MERGE_MSG,gitcommit,*.tmp,*.log", function()
        vim.bo.undofile = false
    end},

    {"BufEnter,FocusGained,InsertLeave,WinEnter", '*', run=function()
        if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
            return
        end

        local lines = vim.api.nvim_buf_line_count(0)
        if lines < 20000 then
            if vim.wo.number and vim.fn.mode() ~= 'i' then
                vim.wo.relativenumber = true
            end
        end
    end, docs="set relative number when focused"},

    {"BufLeave,FocusLost,InsertEnter,WinLeave", '*', run=function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end, docs="unset relative number when unfocused"},

}}

if vim.fn.exists('$TMUX') == 1 then
    util.augroup{"TMUX_RENAME", {
        {'BufEnter', '*', function()
            if vim.bo.buftype == '' then
                local bufname = vim.fn.expand('%:t:S')
                vim.fn.system('tmux rename-window ' .. bufname)
            end
        end},
        {'VimLeave', '*', function()
            vim.fn.system('tmux set-window automatic-rename on')
        end},
    }}
end

util.augroup{"FILETYPE_COMMANDS", {
    {events="Filetype", targets="python,proto", run=function()
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.shiftwidth = 4
    end},

    {"Filetype", "make,automake", docs="makefile tabs", run=function()
        vim.bo.expandtab = false
    end},

    {"BufNewFile,BufRead", ".*aliases", run=function() vim.bo.filetype = 'sh' end},
    {"BufNewFile,BufRead", "Makefile*", run=function() vim.bo.filetype = 'make' end},

    {"TextYankPost", "*", docs="highlihgt yanking", run=function()
        vim.highlight.on_yank{ higroup = "Substitute", timeout = 150 }
    end},

    {"Filetype", "sql,sqls", docs="don't wrap me", run=function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('c', '')
    end},
}}

local async_load_plugin = nil
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
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
