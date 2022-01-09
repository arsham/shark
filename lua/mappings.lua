local quick = require("arshlib.quick")

---vim.v.count
---vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Disabling arrows {{{
vim.keymap.set("n", "<Up>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Down>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Left>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Right>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Up>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Down>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Left>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Right>", "<Nop>", { noremap = true, desc = "disabling arrows" })
--- }}}
-- Moving aroung {{{
-- stylua: ignore start
vim.keymap.set("i", "<A-j>", [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], { noremap = true, silent = true, desc = "move lines down" })
vim.keymap.set("i", "<A-k>", [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], { noremap = true, silent = true, desc = "move lines up" })

vim.keymap.set("x", "<", "<gv",{noremap=true, desc = "Keep the visually selected area when indenting" })
vim.keymap.set("x", ">", ">gv",{noremap=true, desc = "Keep the visually selected area when indenting" })

vim.keymap.set("n", "g=", "gg=Gg``",{noremap=true, desc = "Re-indent the whole buffer" })
-- stylua: ignore end
vim.keymap.set("n", "<C-e>", "2<C-e>", { noremap = true })
vim.keymap.set("n", "<C-y>", "2<C-y>", { noremap = true })

vim.keymap.set(
  "n",
  "k",
  [[(v:count > 2 ? "m'" . v:count : '') . 'k']],
  { noremap = true, expr = true, desc = "numbered motions in the jumplist" }
)
vim.keymap.set(
  "n",
  "j",
  [[(v:count > 2 ? "m'" . v:count : '') . 'j']],
  { noremap = true, expr = true, desc = "numbered motions in the jumplist" }
)
--}}}
-- Insert empty lines {{{

---Inserts empty lines near the cursor.
---@param name string name of the mapping to register for repeating.
---@param count number  Number of lines to insert.
---@param add number 0 to insert after current line, -1 to insert before current
---line.
local function insert_empty_lines(name, count, add)
  if count == 0 then
    count = 1
  end
  local lines = {}
  for i = 1, count do
    lines[i] = ""
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, pos[1] + add, pos[1] + add, false, lines)
  local key = vim.api.nvim_replace_termcodes(name, true, false, true)
  vim.fn["repeat#set"](key, vim.v.count)
end

vim.keymap.set("n", "<Plug>EmptySpaceAfter", function()
  insert_empty_lines("<Plug>EmptySpaceAfter", vim.v.count, 0)
end, { noremap = true, silent = true, desc = "insert [count]empty line(s) below current line" })

vim.keymap.set(
  "n",
  "]<space>",
  "<Plug>EmptySpaceAfter",
  { noremap = true, silent = true, desc = "insert [count]empty line(s) below current line" }
)

-- stylua: ignore start
vim.keymap.set("n", "<Plug>EmptySpaceBefore", function()
  insert_empty_lines("<Plug>EmptySpaceBefore", vim.v.count, -1)
end, { noremap = true, silent = true, desc = "insert [count]empty line(s) below current line" })
vim.keymap.set( "n", "[<space>", "<Plug>EmptySpaceBefore",
  { noremap = true, silent = true, desc = "insert [count]empty line(s) below current line" }
)
--- }}}
-- Resizing windows {{{
vim.keymap.set("n", "<M-Left>", ":vert resize -2<CR>",
  { noremap = true, silent = true, desc = "decreases vertical size" }
)
vim.keymap.set("n", "<M-Right>", ":vert resize +2<CR>",
  { noremap = true, silent = true, desc = "increase vertical size" }
)
vim.keymap.set("n", "<M-Up>", ":resize +2<CR>",
  { noremap = true, silent = true, desc = "increase horizontal size" }
)
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>",
  { noremap = true, silent = true, desc = "decreases horizontal size" }
)
--}}}

vim.keymap.set("n", "G", "Gzz", { noremap = true, desc = "Auto re-centre when moving around" })
vim.keymap.set("n", "g;", "m'g;zz", { noremap = true, desc = "Auto re-centre when moving around" })
vim.keymap.set("n", "g,", "m'g,zz", { noremap = true, desc = "Auto re-centre when moving around" })


vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>",
  { noremap = true, silent = true, desc = "Clear hlsearch" }
)
-- stylua: ignore end

-- Add/remove to/from the end of line(s) {{{
---Add char at the end of a line at the `loc` location.
---@param loc number line number to add the char at.
---@param char string char to add.
---@param content string current content of the line.
---@param remove boolean if false, the char is added, otherwise the last
---character is removed.
local function end_of_line(loc, content, char, remove)
  if remove and (content:sub(-1) ~= char) then
    return
  end
  if remove and #content > 0 then
    content = content:sub(1, -2)
  elseif not remove then
    content = content .. char
  end
  vim.api.nvim_buf_set_lines(0, loc - 1, loc, false, { content })
end

---Add the char at the end of the line, or the visually selected area.
---@param name string the name of mapping to repeat.
---@param char string char to add.
---@param remove boolean if false, the char is added, otherwise the last
---character is removed.
local function change_line_ends(name, char, remove)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" or mode == "i" then
    local loc = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    end_of_line(loc[1], line, char, remove)
  elseif mode == "V" or mode == "CTRL-V" or mode == "v" then
    local start = vim.fn.getpos("v")[2]
    local finish = vim.fn.getcurpos()[2]
    if finish < start then
      start, finish = finish, start
    end
    start = start - 1
    local lines = vim.api.nvim_buf_get_lines(0, start, finish, false)

    for k, line in ipairs(lines) do
      end_of_line(start + k, line, char, remove)
    end
  end

  local key = vim.api.nvim_replace_termcodes(name, true, false, true)
  vim.fn["repeat#set"](key, vim.v.count)
end

-- stylua: ignore start
---Add coma at the end of the line, or the visually selected area.
local end_mapping = {
  ["Period"] = { ".", ">" },
  ["Coma"] = { ",", "lt" },
  ["SemiColon"] = { ";", ":" },
}
for n, tuple in pairs(end_mapping) do
  local name1 = string.format("<Plug>AddEnd%s", n)
  local key1 = "<M-" .. tuple[1] .. ">"
  local desc = string.format("Add %s at the end of line", n)
  vim.keymap.set("n", name1, function() change_line_ends(name1, tuple[1]) end, {noremap=true,desc = desc })
  vim.keymap.set("n", key1, name1,{desc = desc })
  vim.keymap.set("i", key1, function() change_line_ends(name1, tuple[1]) end, {noremap=true,desc = desc })
  vim.keymap.set("v", name1, function() change_line_ends(name1, tuple[1]) end, {noremap=true,desc = desc })
  vim.keymap.set("v", key1, name1,{ desc = desc })

  local name2 = string.format("<Plug>DelEnd%s", n)
  local key2 = "<M-" .. tuple[2] .. ">"
  desc = string.format("Remove %s from the end of line", n)
  vim.keymap.set("n", name2, function() change_line_ends(name2, tuple[1], true) end, {noremap=true,desc = desc })
  vim.keymap.set("n", key2, name2,{desc = desc })
  vim.keymap.set("i", key2, function() change_line_ends(name2, tuple[1], true) end, {noremap=true,desc = desc })
  vim.keymap.set("v", name2, function() change_line_ends(name2, tuple[1], true) end, {noremap=true,desc = desc })
  vim.keymap.set("v", key2, name2,{desc = desc })
end
--- }}}

vim.keymap.set("i", "<M-{>", "<Esc>A {<CR>}<Esc>O",{noremap=true, desc = "Insert a pair of brackets and go into insert mode" })
vim.keymap.set("n", "<M-{>", "A {<CR>}<Esc>O",{noremap=true, desc = "Insert a pair of brackets and go into insert mode" })
-- Yank related {{{
vim.keymap.set("n",  "<Leader>y", '"+y' )
vim.keymap.set("x",  "<Leader>y", '"+y' )
vim.keymap.set("n",  "<Leader>p", '"+p' )
vim.keymap.set("n",  "<Leader>P", '"+P' )

vim.keymap.set("v", "p", '"_dP', { noremap=true, desc = 'replace visually selected with the " contents' })
--}}}
vim.keymap.set("n", "<leader>gw", ":silent lgrep <cword> % <CR>",{noremap=true, silent = true, desc = "grep on local buffer" })

-- Language support {{{
---]s and [s to jump.
---zg to ignore.
vim.keymap.set("n", "<leader>sp", function() vim.wo.spell = not vim.wo.spell end, {noremap=true,desc = "toggle spelling" })
vim.keymap.set("n", "<leader>sf",
  function()
    local spell = vim.wo.spell
    vim.wo.spell = true
    quick.normal("n", "[s1z=``")
    vim.schedule(function()
      vim.wo.spell = spell
    end)
  end, {noremap=true, desc = "auto correct spelling and jump bak.",
})--}}}
-- Merge tool {{{
vim.keymap.set("n", "<leader>1", ":diffget LOCAL<CR>", { noremap = true, desc = "mergetool mapping" })
vim.keymap.set("n", "<leader>2", ":diffget BASE<CR>", { noremap = true, desc = "mergetool mapping" })
vim.keymap.set("n", "<leader>3", ":diffget REMOTE<CR>", { noremap = true, desc = "mergetool mapping" })
--}}}
vim.keymap.set("n", "<leader>jq", ":%!gojq '.'<CR>")

vim.keymap.set("n", "<leader>hh", ":h <CR>", { noremap = true, desc = "Show help for work under the cursor" })
-- stylua: ignore end

vim.keymap.set("n", "&", ":&&<CR>", { noremap = true, desc = "repeat last substitute command" })
vim.keymap.set("x", "&", ":&&<CR>", { noremap = true, desc = "repeat last substitute command" })

vim.keymap.set("n", "<C-w>b", ":bd<CR>", { noremap = true, desc = "delete current buffer" })
vim.keymap.set("n", "<C-w><C-b>", ":bd<CR>", { noremap = true, desc = "delete current buffer" })

-- Execute macros over selected range. {{{
vim.keymap.set("x", "@", function()
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local from = vim.fn.getpos("v")[2]
  local to = vim.fn.getcurpos()[2]
  vim.cmd(string.format("%d,%d normal! @%s", from, to, ch))
end, { noremap = true, silent = false, desc = "execute macro over visual range" })
-- }}}

-- Easier cgn process by starting with already selected text.
vim.keymap.set("n", "cn", "*``cgn")

-- Folding support {{{
vim.keymap.set("n", "<leader>zm", function()
  vim.opt_local.foldmethod = "manual"
end, { noremap = true, silent = true, desc = "set local foldmethod to manual" })

vim.keymap.set("n", "<leader>ze", function()
  vim.opt_local.foldmethod = "expr"
end, { noremap = true, silent = true, desc = "set local foldmethod to expr" })

vim.keymap.set("n", "<leader>zi", function()
  vim.opt_local.foldmethod = "indent"
end, { noremap = true, silent = true, desc = "set local foldmethod to indent" })

vim.keymap.set("n", "<leader>zk", function()
  vim.opt_local.foldmethod = "marker"
end, { noremap = true, silent = true, desc = "set local foldmethod to marker" })

vim.keymap.set("n", "<leader>zs", function()
  vim.opt_local.foldmethod = "syntax"
end, { noremap = true, silent = true, desc = "set local foldmethod to syntax" })
--}}}
--- vim: foldmethod=marker
