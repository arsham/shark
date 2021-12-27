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

---Inserts empty lines near the cursor.
---@param count number  Number of lines to insert.
---@param add number 0 to insert after current line, -1 to insert before current
---line.
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
keymap.nnoremap{"]<space>", function() insert_empty_lines(vim.v.count, 0) end, silent=true}
keymap.nnoremap{"[<space>", function() insert_empty_lines(vim.v.count, -1) end, silent=true}

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
---@param name string the name of mapping to repeat.
---@param char string char to add.
---@param remove boolean if false, the char is added, otherwise the last
-- character is removed.
local function change_line_ends(name, char, remove)
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'n' or mode == 'i' then
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
    keymap.inoremap{key1, function() change_line_ends(name1, tuple[1]) end}
    keymap.vnoremap{name1, function() change_line_ends(name1, tuple[1]) end}
    keymap.vmap{key1, name1}

    local name2 = string.format('<Plug>DelEnd%s', n)
    local key2  = '<M-' .. tuple[2] .. '>'
    keymap.nnoremap{name2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.nmap{key2, name2}
    keymap.inoremap{key2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.vnoremap{name2, function() change_line_ends(name2, tuple[1], true) end}
    keymap.vmap{key2, name2}
end

-- Insert a pair of brackets and go into insert mode.
keymap.inoremap{'<M-{>', '<Esc>A {<CR>}<Esc>O'}
keymap.nnoremap{'<M-{>', 'A {<CR>}<Esc>O'}

keymap.nnoremap{'<Leader>y', '"+y'}
keymap.xnoremap{'<Leader>y', '"+y'}
keymap.nnoremap{'<Leader>p', '"+p'}
keymap.nnoremap{'<Leader>P', '"+P'}

-- select a text, and this will replace it with the " contents.
keymap.vnoremap{'p', '"_dP'}

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

---Returns the indentation of the next line from the given argument, that is
---not empty. All lines are trimmed before examination.
---@param from number the line number to start from.
---@param step number if positive, the next line is traversed, otherwise the
---previous line.
---@param barier number the maximum I will check. Can be 0 or max lines.
---@return number the indentation of the next line.
local function next_unempty_line(from, step, barier)
    for i = from, barier, step do
        local len = #string.gsub(vim.fn.getline(i), "^%s+", "")
        if len > 0 then
            return vim.fn.indent(i)
        end
    end
    return 0
end

---Jumps to the next indentation level equal to current line. It skips empty
---lines, unless the next non-empty line has a lower indentation level. If the
---previous indentation is equal to the current one, and current indentation is
---higher than the nest, it will stop.
---@param down boolean indicates whether we are jumping down.
local function jump_indent(down)
    local main_loc    = vim.api.nvim_win_get_cursor(0)[1]
    local main_len    = #string.gsub(vim.fn.getline(main_loc), "^%s+", "")
    local main_indent = main_len > 0 and vim.fn.indent(main_loc) or 0
    local target      = main_loc
    local barrier     = down and vim.api.nvim_buf_line_count(0) or 0
    local step        = down and 1 or -1
    local in_move     = false

    for i = main_loc, barrier, step do
        local line_len = #string.gsub(vim.fn.getline(i), "^%s+", "")

        if line_len ~= 0 then
            local indent      = vim.fn.indent(i)
            local next_len    = #string.gsub(vim.fn.getline(i + step), "^%s+", "")
            local next_indent = next_len > 0 and vim.fn.indent(i + step) or 0
            local prev_empty  = #string.gsub(vim.fn.getline(i - step), "^%s+", "") == 0
            local prev_indent = prev_empty and 0 or vim.fn.indent(i - step)
            local far_indent  = next_unempty_line(i + step*2, step, barrier)

            local on_main_level      = indent        ==  main_indent
            local cruising           = on_main_level and in_move
            local same_level         = indent        ==  prev_indent
            local leveling_up        = indent        >   prev_indent
            local will_go_up         = indent        <   next_indent
            local may_go_up_the_main = next_indent   >=  main_indent
            local will_go_down       = indent        >   next_indent
            local goes_down_the_main = next_indent   <   main_indent
            local later_will_go_down = indent        >   far_indent
            local later_lower_main   = main_indent   >   far_indent
            local prev_not_empty     = next_len      ~=  0
            local next_is_empty      = next_len      ==  0
            local road_block         = will_go_down  and prev_not_empty

            if later_will_go_down and next_is_empty and later_lower_main then
                break
            elseif same_level and on_main_level then
                if road_block then
                    -- the next line also coule be empty.
                    break
                elseif in_move then
                    if will_go_up or goes_down_the_main then
                        break
                    end
                end
            elseif leveling_up then
                if cruising and prev_empty then
                    break
                elseif not may_go_up_the_main and prev_not_empty then
                    break
                end
            elseif cruising then
                break
            elseif road_block and not in_move then
                break
            end
        end

        in_move = true
        target = i + step
    end

    local sequence = string.format("%dgg_", target)
    util.normal('xt', sequence)
end

vim.keymap.nnoremap{']=', function() jump_indent(true)  end}
vim.keymap.nnoremap{'[=', function() jump_indent(false) end}

vim.keymap.nnoremap{'&', ':&&<CR>'}
vim.keymap.xnoremap{'&', ':&&<CR>'}

---Delete the buffer.
vim.keymap.nnoremap{'<C-w>b', ':bd<CR>'}
vim.keymap.nnoremap{'<C-w><C-b>', ':bd<CR>'}
