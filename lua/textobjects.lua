local util = require('util')
require('astronauta.keymap')

local function nextObj(motion)
    local c = vim.fn.getchar()
    local ch = vim.fn.nr2char(c)
    local sequence = "f" .. ch .. "v" .. motion .. ch
    local keys = util.termcodes(sequence)
    vim.api.nvim_feedkeys(keys, 'x', false)
end

vim.keymap.xnoremap{'an', function() nextObj("a") end}
vim.keymap.onoremap{'an', function() nextObj("a") end}
vim.keymap.xnoremap{'in', function() nextObj("i") end}
vim.keymap.onoremap{'in', function() nextObj("i") end}

-- Copied from https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local chars = {'_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' }
for char in util.values(chars) do
	vim.keymap.xnoremap{'i' .. char, ':<C-u>normal! T' .. char .. 'vt' .. char .. '<CR>'}
	vim.keymap.onoremap{'i' .. char, ':normal vi'      .. char .. '<CR>'}
	vim.keymap.xnoremap{'a' .. char, ':<C-u>normal! F' .. char .. 'vf' .. char .. '<CR>'}
	vim.keymap.onoremap{'a' .. char, ':normal va'      .. char .. '<CR>'}
end


 -- Number pseudo-text object (integer and float)
 -- Exmaple: ciN
local function visualNumber()
	vim.fn.search('\\d\\([^0-9\\.]\\|$\\)', 'cW')
    local keys = util.termcodes('v')
    vim.api.nvim_feedkeys(keys, 'x', false)
	vim.fn.search('\\(^\\|[^0-9\\.]\\d\\)', 'becW')
end

vim.keymap.xnoremap{'iN', visualNumber}
vim.keymap.onoremap{'iN', visualNumber}
