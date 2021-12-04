local util = require('util')
require('astronauta.keymap')
local keymap = vim.keymap

-- vim.v.count
-- vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = ' '

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

-- insert empty lines with motions, can be 10[<space>
-- TODO: can we use nvim_buf_set_text?
keymap.nnoremap{"[<space>", silent=true, ":<c-u>put!=repeat([''],v:count)<bar>']+1<cr>"}
keymap.nnoremap{"]<space>", silent=true, ":<c-u>put =repeat([''],v:count)<bar>'[-1<cr>"}

keymap.nnoremap{'<C-h>', '<C-w><C-h>'}
keymap.nnoremap{'<C-j>', '<C-w><C-j>'}
keymap.nnoremap{'<C-k>', '<C-w><C-k>'}
keymap.nnoremap{'<C-l>', '<C-w><C-l>'}

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

-- Terminal mappings.
-- keymap.tnoremap{'<C-R>', [[<C-\\><C-N>"'.nr2char(getchar()).'pi']]}
-- keymap.tnoremap{'<C-w><C-h>', '<C-\\><C-N><C-w>h'}
-- keymap.tnoremap{'<C-w><C-j>', '<C-\\><C-N><C-w>j'}
-- keymap.tnoremap{'<C-w><C-k>', '<C-\\><C-N><C-w>k'}
-- keymap.tnoremap{'<C-w><C-l>', '<C-\\><C-N><C-w>l'}

-- Add comma/period at the end of the line.
keymap.inoremap{'<M-,>', '<Esc>m`A,<Esc>``a'}
keymap.nnoremap{'<M-,>', 'm`A,<Esc>``'}
keymap.inoremap{'<M-.>', '<Esc>m`A.<Esc>``a'}
keymap.nnoremap{'<M-.>', 'm`A.<Esc>``'}

-- Insert a pair of brackets and go into insert mode.
keymap.inoremap{'<M-{>', '<Esc>A {<CR>}<Esc>O'}
keymap.nnoremap{'<M-{>', 'A {<CR>}<Esc>O'}

keymap.noremap{'<Leader>y', '"+y'}
keymap.noremap{'<Leader>p', '"+p'}
keymap.noremap{'<Leader>P', '"+P'}
keymap.nnoremap{'Y', 'y$'}

-- select a text, and this will replace it with the " contents.
keymap.vnoremap{'<leader>p', '"_dP'}

-- let the visual mode use the period. To add : at the begining of all lines:
-- I:<ESC>j0vG.
keymap.vnoremap{'.', ':norm.<CR>'}

keymap.nnoremap{'<leader>gw', ':silent grep <cword> % <CR>', silent=true}

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
