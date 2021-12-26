if not pcall(require, 'astronauta.keymap') then return end
local nvim = require('nvim')
local keymap = vim.keymap
local util = require('settings.fzf.util')

-- Ctrl+/ for searching in current buffer.
keymap.nnoremap{'<leader>:', ':Commands<CR>'}
keymap.nnoremap{'<C-_>',      util.lines_grep,    silent=true}
keymap.nnoremap{'<M-/>',      ':Lines<CR>',       silent=true}
keymap.nnoremap{'<C-p>',      ':Files<CR>',       silent=true}
keymap.nnoremap{'<M-p>',      ':Files ~/<CR>',    silent=true}
keymap.nnoremap{'<C-b>',      ':Buffers<CR>',     silent=true}
keymap.nnoremap{'<M-b>',      util.delete_buffer, silent=true}
keymap.nnoremap{'<leader>gf', ':GFiles<CR>',      silent=true}
keymap.nnoremap{'<leader>fh', ':History<CR>',     silent=true}

-- Run locate.
keymap.nnoremap{'<leader>fl', silent=true, function()
    require('util').user_input{
        prompt = "Term: ",
        on_submit = function(term)
            vim.schedule(function()
                local preview = vim.fn["fzf#vim#with_preview"]()
                vim.fn["fzf#vim#locate"](term, preview)
            end)
        end,
    }
end}

-- Replace the default dictionary completion with fzf-based fuzzy completion.
keymap.inoremap{'<c-x><c-k>', expr=true, [[fzf#vim#complete('cat /usr/share/dict/words-insane')]]}
keymap.imap{'<c-x><c-f>', '<plug>(fzf-complete-path)'}
keymap.imap{'<c-x><c-l>', '<plug>(fzf-complete-line)'}

-- Open the search tool.
keymap.nnoremap{"<leader>ff", function() util.ripgrep_search("") end}
-- Open the search tool, ignoring .gitignore.
keymap.nnoremap{"<leader>fa", function() util.ripgrep_search("", true) end}
-- Incremental search.
keymap.nnoremap{"<leader>fi", function() util.ripgrep_search_incremental("", true) end}

-- Search over current word.
keymap.nnoremap{"<leader>rg", function()
    util.ripgrep_search(vim.fn.expand("<cword>"))
end}
-- Search over current word, ignoring .gitignore.
keymap.nnoremap{"<leader>ra", function()
    util.ripgrep_search(vim.fn.expand("<cword>"), true)
end}
-- Incremental search over current word, ignoring .gitignore.
keymap.nnoremap{"<leader>ri", function()
    util.ripgrep_search(vim.fn.expand("<cword>"), true)
end}

keymap.nnoremap{'<leader>mm',  ":Marks<CR>"}

keymap.nnoremap{'z=', function()
    local term = vim.fn.expand("<cword>")
    vim.fn["fzf#run"]({
        source = vim.fn.spellsuggest(term),
        sink = function(new_term)
            require('util').normal('n', '"_ciw' .. new_term .. '')
        end,
        down = 10,
    })
end}

vim.keymap.nnoremap{'<leader>@', nvim.ex.BTags, silent=true}
