vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "50,72"
vim.opt_local.spell = true
vim.wo.cursorline = true
vim.opt_local.formatoptions:remove({ "c", "r", "o", "q" })
vim.cmd.startinsert()

-- From 50's character of the first line to the end.
vim.fn.matchaddpos("Error", { { 1, 50, 10000 } })

-- stylua: ignore start
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
-- stylua: ignore end
