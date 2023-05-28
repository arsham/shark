local quick = require("arshlib.quick")

vim.opt_local.spell = true
vim.opt_local.softtabstop = 1 -- if I have two spaces in a sentence, delete only one.
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.autoindent = true
vim.opt_local.formatoptions = "12crqnot"
vim.opt_local.comments = "n:>"
vim.opt_local.wrap = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "min:50,shift:2"
vim.opt_local.commentstring = "<!--%s-->"
vim.opt_local.conceallevel = 2

-- Formating support {{{
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
vim.opt_local.formatlistpat = table.concat(formatlistpat, '')
vim.opt_local.comments = 'b:*,b:-'
vim.opt_local.foldtext = 'v:lua.custom_foldtext()'
vim.opt_local.foldmethod = 'expr'
--}}}
-- stylua: ignore end

vim.keymap.set("i", "<CR>", function()
  local line = vim.fn.getline(vim.fn.line(".")):gsub("^%s*", "")
  local marker = vim.fn.matchstr(line, [[^\(\d\+\.\)\s]])
  if not marker and marker == line then
    return vim.api.nvim_replace_termcodes("<c-u>", true, false, true) .. marker
  end
  local m = tonumber(marker)
  if m then
    marker = tostring(m + 1) .. ". "
  end
  return vim.api.nvim_replace_termcodes("<cr>", true, false, true) .. marker
end, { expr = true, buffer = true, desc = "create lists in markdown" })

-- Jumps to the next heading {{{
---@param down boolean if goes to next, otherwise to the previous.
local function nextHeading(down)
  local count = vim.v.count
  local col = vim.fn.col(".")

  local flags = "W"
  if down then
    flags = "bW"
  end
  vim.fn.search("^#", flags)

  if count > 1 then
    if col == 1 then
      count = count - 1
    end
    quick.normal("nx", string.rep("n", count))
  end

  local motion = string.format("%d|", col)
  quick.normal("nx", motion)
end

local next_heading = function()
  nextHeading(false)
end
local prev_heading = function()
  nextHeading(true)
end

local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
if ok then
  next_heading, prev_heading = ts_repeat_move.make_repeatable_move_pair(function()
    nextHeading(false)
  end, function()
    nextHeading(true)
  end)
end
local desc = "jump to the next heading in markdown document"
vim.keymap.set("n", "]]", next_heading, { buffer = true, silent = true, desc = desc })
vim.keymap.set("n", "[[", prev_heading, { buffer = true, silent = true, desc = desc })

vim.keymap.set("x", "<C-b>", "s**<Esc>pa**<Esc>", { desc = "Make selection bold", buffer = true })

--}}}
-- vim: fdm=marker fdl=0
