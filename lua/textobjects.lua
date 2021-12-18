local util = require('util')
require('astronauta.keymap')

-- vnoremap <silent> af :<C-u>lua require'nvim-treesitter.textobjects.select'.select_textobject('@function.outer')<CR>

local function next_obj(motion)
    local c = vim.fn.getchar()
    local ch = vim.fn.nr2char(c)
    local sequence = "f" .. ch .. "v" .. motion .. ch
    util.normal('x', sequence)
end

vim.keymap.xnoremap{'an', function() next_obj("a") end}
vim.keymap.onoremap{'an', function() next_obj("a") end}
vim.keymap.xnoremap{'in', function() next_obj("i") end}
vim.keymap.onoremap{'in', function() next_obj("i") end}

-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local chars = {'_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '-', '#' }
for char in table.values(chars) do
    vim.keymap.xnoremap{'i' .. char, function()
        util.normal('xt', 'T' .. char .. 'ot' .. char)
    end}
    vim.keymap.onoremap{'i' .. char, function()
        util.normal('x', 'vi' .. char)
    end}
    vim.keymap.xnoremap{'a' .. char, function()
        util.normal('xt', 'F' .. char .. 'of' .. char)
    end}
    vim.keymap.onoremap{'a' .. char, function()
        util.normal('x', 'va' .. char)
    end}
end

-- line pseudo text objects.
vim.keymap.xnoremap{'il', function() util.normal('xt', 'g_o^') end}
vim.keymap.onoremap{'il', function() util.normal('x',  'vil')  end}
vim.keymap.xnoremap{'al', function() util.normal('xt', '$o0')  end}
vim.keymap.onoremap{'al', function() util.normal('x',  'val')  end}

---Number pseudo-text object (integer and float)
---Exmaple: ciN
local function visual_number()
    vim.fn.search('\\d\\([^0-9\\.]\\|$\\)', 'cW')
    util.normal('x', 'v')
    vim.fn.search('\\(^\\|[^0-9\\.]\\d\\)', 'becW')
end
vim.keymap.xnoremap{'iN', visual_number}
vim.keymap.onoremap{'iN', visual_number}

---Selects all lines with equal or higher indents to the current line in line
---visual mode. It ignores any empty lines.
local function in_indent()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    local cur_indent = vim.fn.indent(cur_line)
    local total_lines = vim.api.nvim_buf_line_count(0)

    local first_line = cur_line
    for i = cur_line,0,-1 do
        if cur_indent == 0 and #vim.fn.getline(i) == 0 then
            -- If we are at column zero, we will stop at an empty line.
            break
        end
        if #vim.fn.getline(i) ~= 0 then
            local indent = vim.fn.indent(i)
            if indent < cur_indent then
                break
            end
        end
        first_line = i
    end

    local last_line = cur_line
    for i = cur_line,total_lines,1 do
        if cur_indent == 0 and #vim.fn.getline(i) == 0 then
            break
        end
        if #vim.fn.getline(i) ~= 0 then
            local indent = vim.fn.indent(i)
            if indent < cur_indent then
                break
            end
        end
        last_line = i
    end

    local sequence = string.format("%dgg0o%dgg$$", first_line, last_line)
    util.normal('xt', sequence)
end

vim.keymap.vnoremap{'ii', in_indent, silent=true}
vim.keymap.onoremap{'ii', function() util.normal('x',  'vii')  end}

---@param include boolean if true, will remove the backticks too.
local function in_backticks(include)
    util.normal('n', "m'")
    vim.fn.search('`', 'bcsW')
    local motion = ''
    if not include then
        motion = 'l'
    end

    util.normal('x', motion .. 'o')
    vim.fn.search('`', '')

    if include then return end
    util.normal('x', 'h')
end

vim.keymap.vnoremap{'i`', function() in_backticks(false) end,     silent = true}
vim.keymap.vnoremap{'a`', function() in_backticks(true) end,      silent = true}
vim.keymap.onoremap{'i`', function() util.normal('x', 'vi`') end, silent = true}
vim.keymap.onoremap{'a`', function() util.normal('x', 'va`') end, silent = true}

vim.keymap.onoremap{'H', '^'}
vim.keymap.onoremap{'L', '$'}
