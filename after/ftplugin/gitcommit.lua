local bufname = vim.fn.bufname()
if vim.fn.getbufvar(bufname, 'ftplugin_loaded') == true then return end
vim.fn.setbufvar(bufname, 'ftplugin_loaded', true)

---see #14670
---vim.bo.textwidth = 72
---vim.wo.colorcolumn = "50,72"
---vim.wo.spell = true
local nvim = require('nvim')
nvim.ex.setlocal('spell')
nvim.ex.setlocal('textwidth=72')
nvim.ex.setlocal('colorcolumn="50,72"')
nvim.ex.startinsert()

vim.bo.formatoptions = vim.bo.formatoptions .. 'cn'
local formatlistpat = {'^\\s*'}                         --- Optional leading whitespace
table.insert(formatlistpat, '[')                        --- Start character class
table.insert(formatlistpat, '\\[({]\\?')                --- |  Optionally match opening punctuation
table.insert(formatlistpat, '\\(')                      --- |  Start group
table.insert(formatlistpat, '[0-9]\\+')                 --- |  |  Numbers
table.insert(formatlistpat, [[\\\|]])                   --- |  |  or
table.insert(formatlistpat, '[a-zA-Z]\\+')              --- |  |  Letters
table.insert(formatlistpat, '\\)')                      --- |  End group
table.insert(formatlistpat, '[\\]:.)}')                 --- |  Closing punctuation
table.insert(formatlistpat, ']')                        --- End character class
table.insert(formatlistpat, '\\s\\+')                   --- One or more spaces
table.insert(formatlistpat, [[\\\|]])                   --- or
table.insert(formatlistpat, '^\\s*[-+*]\\s\\+')         --- Bullet points
vim.bo.formatlistpat = table.concat(formatlistpat, '')
vim.wo.cursorline = true
