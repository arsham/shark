require('astronauta.keymap')
local util = require('util')
local keymap = vim.keymap

-- vim.v.count
-- vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap.noremap{'<Up>',     '<Nop>'}
keymap.noremap{'<Down>',   '<Nop>'}
keymap.noremap{'<Left>',   '<Nop>'}
keymap.noremap{'<Right>',  '<Nop>'}
keymap.inoremap{'<Up>',    '<Nop>'}
keymap.inoremap{'<Down>',  '<Nop>'}
keymap.inoremap{'<Left>',  '<Nop>'}
keymap.inoremap{'<Right>', '<Nop>'}
-- Disable Ex mode
keymap.nmap{'Q', '<Nop>'}

-- Moving lines with alt key.
keymap.nnoremap{'<A-j>', silent=true, [[:<c-u>execute 'm +'. v:count1<cr>==]]}
keymap.nnoremap{'<A-k>', silent=true, [[:<c-u>execute 'm -1-'. v:count1<cr>==]]}
keymap.inoremap{'<A-j>', silent=true, [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]]}
keymap.inoremap{'<A-k>', silent=true, [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]]}
keymap.vnoremap{'<A-j>', silent=true, [[:m '>+1<CR>gv=gv]]}
keymap.vnoremap{'<A-k>', silent=true, [[:m '<-2<CR>gv=gv]]}

-- Keep the visually selected area when indenting.
keymap.xnoremap{'<', '<gv'}
keymap.xnoremap{'>', '>gv'}

-- Re-indent the whole buffer.
keymap.nnoremap{'g=', 'gg=Gg``'}

-- Inserts empty lines near the cursor.
-- @param count(int): Number of lines to insert.
-- @param add(int): 0 to insert after current line, -1 to insert before current
-- line.
local function insert_empty_lines(count, add)
    if count == 0 then count = 1 end
    local lines = {}
    for i = 1,count do
        lines[i] = ''
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, pos[1]+add, pos[1]+add, false, lines)
end

-- insert empty lines with motions, can be 10[<space>
keymap.nnoremap{"]<space>", function()
    insert_empty_lines(vim.v.count, 0)
end, silent=true}
keymap.nnoremap{"[<space>", function()
    insert_empty_lines(vim.v.count, -1)
end, silent=true}

keymap.nnoremap{'<M-Left>',  silent=true, ':vert resize -2<CR>'}
keymap.nnoremap{'<M-Right>', silent=true, ':vert resize +2<CR>'}
keymap.nnoremap{'<M-Up>',    silent=true, ':resize +2<CR>'}
keymap.nnoremap{'<M-Down>',  silent=true, ':resize -2<CR>'}

keymap.nnoremap{'<C-e>', '2<C-e>'}
keymap.nnoremap{'<C-y>', '2<C-y>'}

-- Auto re-centre when moving around
keymap.nnoremap{'G', "Gzz"}
keymap.nnoremap{'g;', "m'g;zz"}
keymap.nnoremap{'g,', "m'g,zz"}

-- put numbered motions in the jumplist.
keymap.nnoremap{'k', expr=true, [[(v:count > 2 ? "m'" . v:count : '') . 'k']]}
keymap.nnoremap{'j', expr=true, [[(v:count > 2 ? "m'" . v:count : '') . 'j']]}

-- Clear hlsearch
keymap.nnoremap{'<Esc><Esc>', silent=true, ':noh<CR>'}

-- Add char at the end of a line at the `loc` location.
-- @param loc(int): line number to add the char at.
-- @param char(string): char to add.
-- @param content(string): current content of the line.
-- @param remote(bool): if false, the char is added, otherwise the last
-- character is removed.
local function end_of_line(loc, content, char, remove)
    if remove and (content:sub(-1) ~= char) then
        return
    end
    if remove and #content > 0 then
        content = content:sub(1, -2)
    elseif not remove then
        content = content .. char
    end
    vim.api.nvim_buf_set_lines(0, loc-1, loc, false, {content})
end

-- Add the char at the end of the line, or the visually selected area.
-- @param name(string): the name of mapping to repeat.
-- @param char(string): char to add.
-- @param remove(bool): if false, the char is added, otherwise the last
-- character is removed.
local function change_line_ends(name, char, remove)
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'n' or mode == 'i' then
        local loc = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        end_of_line(loc[1], line, char, remove)
    elseif mode == "V" or mode == "CTRL-V" or mode == "\22" then
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

-- Add coma at the end of the line, or the visually selected area.
local end_mapping = {
    ['Period']    = {'.', '>'},
    ['Coma']      = {',', 'lt'},
    ['SemiColon'] = {';', ':'},
}
for n, tuple in pairs(end_mapping) do
    local name1 = string.format('<Plug>AddEnd%s', n)
    local key1  = '<M-' .. tuple[1] .. '>'
    keymap.nnoremap{name1, function() change_line_ends(name1, tuple[1]) end}
    keymap.nmap{key1, name1}
    keymap.inoremap{name1, function() change_line_ends(name1, tuple[1]) end}
    keymap.imap{key1, name1}
    keymap.vnoremap{name1, function() change_line_ends(name1, tuple[1]) end}
    keymap.vmap{key1, name1}

    local name2 = string.format('<Plug>DelEnd%s', n)
    local key2  = '<M-' .. tuple[2] .. '>'
    keymap.nnoremap{name2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.nmap{key2, name2}
    keymap.inoremap{name2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.imap{key2, name2}
    keymap.vnoremap{name2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.vmap{key2, name2}
end

-- Insert a pair of brackets and go into insert mode.
keymap.inoremap{'<M-{>', '<Esc>A {<CR>}<Esc>O'}
keymap.nnoremap{'<M-{>', 'A {<CR>}<Esc>O'}

keymap.noremap{'<Leader>y', '"+y'}
keymap.noremap{'<Leader>p', '"+p'}
keymap.noremap{'<Leader>P', '"+P'}

-- select a text, and this will replace it with the " contents.
keymap.vnoremap{'<leader>p', '"_dP'}

-- let the visual mode use the period. To add : at the begining of all lines:
-- I:<ESC>j0vG.
keymap.vnoremap{'.', ':norm.<CR>'}

keymap.nnoremap{'<leader>gw', ':silent lgrep <cword> % <CR>', silent=true}

-- ]s and [s to jump.
-- zg to ignore.
keymap.nnoremap{'<leader>sp', function() vim.wo.spell = not vim.wo.spell end}
-- auto correct spelling and jump bak.
keymap.nnoremap{'<leader>sf', function()
    local spell = vim.wo.spell
    vim.wo.spell = true
    util.normal('n', "[s1z=``")
    vim.schedule(function()
        vim.wo.spell = spell
    end)
end}

-- mergetool mappings.
keymap.nnoremap{'<leader>1', ':diffget LOCAL<CR>'}
keymap.nnoremap{'<leader>2', ':diffget BASE<CR>'}
keymap.nnoremap{'<leader>3', ':diffget REMOTE<CR>'}

keymap.nnoremap{'<leader>jq', ":%!gojq '.'<CR>"}

-- Show help for work under the cursor.
keymap.nnoremap{'<leader>hh',  ":h <CR>"}
