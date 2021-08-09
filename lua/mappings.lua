require('astronauta.keymap')
local keymap = vim.keymap

vim.g.mapleader = ' '

keymap.noremap{'<Up>', '<Nop>'}
keymap.noremap{'<Down>', '<Nop>'}
keymap.noremap{'<Left>', '<Nop>'}
keymap.noremap{'<Right>', '<Nop>'}
keymap.inoremap{'<Up>', '<Nop>'}
keymap.inoremap{'<Down>', '<Nop>'}
keymap.inoremap{'<Left>', '<Nop>'}
keymap.inoremap{'<Right>', '<Nop>'}
-- " Disable Ex mode
keymap.nmap{'Q', '<Nop>'}

-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap.xmap{'ga', '<Plug>(EasyAlign)'}
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap.nmap{'ga', '<Plug>(EasyAlign)'}

-- make the regular expression less crazy
keymap.nnoremap{'/', '/\\v'}
keymap.vnoremap{'/', '/\\v'}
keymap.nnoremap{'?', '?\\v'}
keymap.vnoremap{'?', '?\\v'}

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

-- Re-indent the whole file.
keymap.nnoremap{'g=', 'gg=Gg``'}

-- insert empty lines with motions, can be 10[<space>
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

keymap.nmap{'<C-W>z', '<Plug>(zoom-toggle)'}


-- " Terminal mappings.
-- tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
-- tnoremap <C-w><C-h> <C-\><C-N><C-w>h
-- tnoremap <C-w><C-j> <C-\><C-N><C-w>j
-- tnoremap <C-w><C-k> <C-\><C-N><C-w>k
-- tnoremap <C-w><C-l> <C-\><C-N><C-w>l

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

keymap.nnoremap{'<leader>@', ':DocumentSymbols<cr>'}
keymap.nnoremap{'<leader>:', ':Commands<CR>'}
keymap.nnoremap{'<C-p>', silent=true, ':Files<CR>'}
keymap.nnoremap{'<C-b>', silent=true, ':Buffers<CR>'}
keymap.nnoremap{'<C-_>', silent=true, ':BLines<CR>'}

keymap.nnoremap{'<leader>fl', silent=true, function()
    local term = vim.fn.input({prompt="Term: "})
    local run = string.format("call fzf#vim#locate('%s', fzf#vim#with_preview())", term)
    vim.cmd(run)
end}
keymap.nnoremap{'<leader>gg', silent=true, ':GGrep<CR>'}
keymap.nnoremap{'<leader>gf', silent=true, ':GFiles<CR>'}-->
keymap.nnoremap{'<leader>fh', silent=true, ':History<CR>'}

keymap.nnoremap{']q', ':cnext<CR>'}-->>
keymap.nnoremap{'[q', ':cprevious<CR>'}

-- Replace the default dictionary completion with fzf-based fuzzy completion>
keymap.inoremap{'<c-x><c-k>', expr=true, [[fzf#vim#complete('cat /usr/share/dict/words-insane')]]}


-- auto correct spelling and jump back.
local function fixLastSpellingError()
    local spell = vim.wo.spell
    vim.wo.spell = true
    local correction = require('util').termcodes("[s1z=``")
    vim.api.nvim_feedkeys(correction, 'n', true)
    vim.schedule(function()
        vim.wo.spell = spell
    end)
end
keymap.nnoremap{'<leader>sp', fixLastSpellingError}--<<

-- Opens the fzf UI with ripgrep search.
local command = {
    "command! -bang -nargs=* ArshamRg ",
    "call fzf#vim#grep(",
    [['rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- '.shellescape(<q-args>), 1,]],
    "fzf#vim#with_preview(), <bang>0)",
}
vim.cmd(table.concat(command, " "))

-- Open the search tool.
keymap.nnoremap{"<leader>ff", ':ArshamRg<CR>'}
-- Search over current word.
keymap.nnoremap{"<leader>rg", [[:ArshamRg <C-R>=expand("<cword>")<CR><CR>]]}

keymap.nnoremap{'<leader>1', ':diffget LOCAL<CR>'}
keymap.nnoremap{'<leader>2', ':diffget BASE<CR>'}
keymap.nnoremap{'<leader>3', ':diffget REMOTE<CR>'}
