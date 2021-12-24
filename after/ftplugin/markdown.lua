require('astronauta.keymap')
local nvim = require('nvim')
-- see #14670
-- vim.opt_local.spell = true
nvim.ex.setlocal('spell')
vim.bo.softtabstop = 1  -- if I have two spaces in a sentence, delete only one.
vim.bo.autoindent = true
vim.bo.textwidth = 0
vim.bo.formatoptions = '12crqno'
vim.bo.comments = 'n:>'
vim.wo.wrap = true
vim.wo.conceallevel = 0
vim.wo.breakindent = true
vim.wo.breakindentopt = 'min:50,shift:2'
vim.bo.commentstring = '<!--%s-->'
local formatlistpat = {'^\\s*'}                         -- Optional leading whitespace
table.insert(formatlistpat, '[')                        -- Start character class
table.insert(formatlistpat, '\\[({]\\?')                -- |  Optionally match opening punctuation
table.insert(formatlistpat, '\\(')                      -- |  Start group
table.insert(formatlistpat, '[0-9]\\+')                 -- |  |  Numbers
table.insert(formatlistpat, [[\\\|]])                   -- |  |  or
table.insert(formatlistpat, '[a-zA-Z]\\+')              -- |  |  Letters
table.insert(formatlistpat, '\\)')                      -- |  End group
table.insert(formatlistpat, '[\\]:.)}')                 -- |  Closing punctuation
table.insert(formatlistpat, ']')                        -- End character class
table.insert(formatlistpat, '\\s\\+')                   -- One or more spaces
table.insert(formatlistpat, [[\\\|]])                   -- or
table.insert(formatlistpat, '^\\s*[-+*]\\s\\+')         -- Bullet points
vim.bo.formatlistpat = table.concat(formatlistpat, '')
vim.bo.comments = 'b:*,b:-'
vim.wo.foldexpr = 'v:lua.FoldMarkdown(v:lnum)'

function _G.FoldMarkdown(line_number)
    local level = vim.fn.matchend(vim.fn.getline(line_number), '^#*')
    local nextlevel =  vim.fn.matchend(vim.fn.getline(line_number + 1), '^#*')
    if level > 0 then
        return '>' .. level
    elseif nextlevel > 0 then
        return '<' .. nextlevel
    end
    return '='
end

vim.wo.foldmethod = 'expr'

vim.keymap.inoremap{'<CR>', function()
    local line = vim.fn.substitute(vim.fn.getline(vim.fn.line('.')), '^\\s*', '', '')
    local marker = vim.fn.matchstr(line, [[^\([*-]\|\d\+\.\)\s]])
    if not marker and marker == line then
        return "\\<c-u>"
    end
    if marker ~= '\\d' then
        marker = tostring(tonumber(marker) + 1) .. '. '
    end
    return "\\<cr>" .. marker
end, expr=true, buffer=true}
