local util = require('util')
require('astronauta.keymap')

util.autocmd{"LINE_RETURN", {
    {"BufReadPost", "*", function()
        local line = vim.fn.line
        if line("'\"") > 0 and line("'\"") <= line("$") then
            vim.cmd[[normal! g`"zvzz']]
        end
    end},
}}

util.autocmd{"FILETYPE_COMMANDS", {
    {events="Filetype", targets="python", run=function()
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.shiftwidth = 4
    end},
    -- Ensure tabs don't get converted to spaces in Makefiles.
    {events="Filetype", targets="make,automake", run=function() vim.bo.expandtab = false end},
    {events="Filetype", targets="markdown",      run=function() vim.wo.spell = true end},
    {events="Filetype", targets="gitcommit",     run=function()
        vim.bo.textwidth = 72
        vim.wo.colorcolumn = "50,72"
        vim.wo.spell = true
    end},
    {"BufNewFile,BufRead", targets=".*aliases",  run="set ft=sh"},

    -- Do no wrap in go.mod files.
    {events="BufNewFile,BufRead", targets="go.mod", run=function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    end},


    -- highlight yanking.
    {events="TextYankPost", targets="*", run=function()
        vim.highlight.on_yank{ higroup = "Substitute", timeout = 150 }
    end},
    -- resize Split When the window is resized
    {events="VimResized", targets="*", run=":wincmd ="},

    -- fix escape in fzf popup.
    {events="FileType", targets="fzf", run="tnoremap <buffer> <esc> <c-c>"},

    -- auto reload file if changed, need the following two
    -- reload files changed outside vim
    {events="FileChangedShell", targets="*", run='echo "Warning: File changed on disk"'},
    -- au FocusGained,BufEnter * : checktime

    {events="BufRead,BufNewFile", targets="*/templates/*.yaml,*/templates/*.tpl", run="LspStop"},

    -- TODO: remove me!
    {events="BufNewFile,BufRead", targets="runme.sh", run="set ft=text"},

    -- browser setup.
    -- autocmd BufEnter github.com_*.txt set filetype=markdown
    -- autocmd BufEnter play.golang.org_*.txt set filetype=go
}}

local function strip()
    if vim.bo.binary or vim.bo.filetype == 'diff' then
        return
    end
    local save = vim.fn.winsaveview()
    vim.cmd[[ keeppatterns %s/\s\+$//e ]]
    vim.cmd[[silent! %s#\($\n\s*\)\+\%$##]]
    vim.fn.winrestview(save)
end

util.autocmd{"TRIMSPACES", {
    {events="BufWritePre,FileWritePre,FileAppendPre,FilterWritePre", targets="*", run=strip}
}}
