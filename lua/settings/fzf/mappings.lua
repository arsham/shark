local nvim = require('nvim')
local util = require('util')
local fzf = require('settings.fzf.util')

---Ctrl+/ for searching in current buffer.
util.nnoremap{'<leader>:', ':Commands<CR>'}
util.nnoremap{'<C-_>',     fzf.lines_grep,     silent=true}
util.nnoremap{'<M-/>',     ':Lines<CR>',       silent=true}
util.nnoremap{'<C-p>',     ':Files<CR>',       silent=true}
util.nnoremap{'<M-p>',     ':Files ~/<CR>',    silent=true}
util.nnoremap{'<C-b>',     ':Buffers<CR>',     silent=true}
util.nnoremap{'<M-b>',     fzf.delete_buffer,  silent=true}
util.nnoremap{'<leader>gf', ':GFiles<CR>',     silent=true}
util.nnoremap{'<leader>fh', ':History<CR>',    silent=true}

---Run locate.
util.nnoremap{'<leader>fl', function()
    require('util').user_input{
        prompt = "Term: ",
        on_submit = function(term)
            vim.schedule(function()
                local preview = vim.fn["fzf#vim#with_preview"]()
                vim.fn["fzf#vim#locate"](term, preview)
            end)
        end,
    }
end, silent=true}

---Replace the default dictionary completion with fzf-based fuzzy completion.
util.inoremap{'<c-x><c-k>', [[fzf#vim#complete('cat /usr/share/dict/words-insane')]], expr=true}
util.imap{'<c-x><c-f>', '<plug>(fzf-complete-path)'}
util.imap{'<c-x><c-l>', '<plug>(fzf-complete-line)'}

---Open the search tool.
util.nnoremap{"<leader>ff", function() fzf.ripgrep_search("") end, desc="find in files"}
---Open the search tool, ignoring .gitignore.
util.nnoremap{"<leader>fa", function() fzf.ripgrep_search("", true) end}
---Incremental search.
util.nnoremap{"<leader>fi", function() fzf.ripgrep_search_incremental("", true) end}

---Search over current word.
util.nnoremap{"<leader>rg", function()
    fzf.ripgrep_search(vim.fn.expand("<cword>"))
end}
---Search over current word, ignoring .gitignore.
util.nnoremap{"<leader>ra", function()
    fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end}
---Incremental search over current word, ignoring .gitignore.
util.nnoremap{"<leader>ri", function()
    fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end}

util.nnoremap{'<leader>mm', ":Marks<CR>"}

util.nnoremap{'z=', function()
    local term = vim.fn.expand("<cword>")
    vim.fn["fzf#run"]({
        source = vim.fn.spellsuggest(term),
        sink = function(new_term)
            require('util').normal('n', '"_ciw' .. new_term .. '')
        end,
        down = 10,
    })
end}

util.nnoremap{'<leader>@', nvim.ex.BTags, silent=true}
