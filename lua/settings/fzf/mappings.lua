require('astronauta.keymap')
local keymap = vim.keymap

keymap.nnoremap{'<leader>:', ':Commands<CR>'}
keymap.nnoremap{'<C-p>',     ':Files<CR>',      silent=true}
keymap.nnoremap{'<C-b>',     ':Buffers<CR>',    silent=true}
keymap.nnoremap{'<M-b>',     ':BDelete<CR>',    silent=true}
keymap.nnoremap{'<C-_>',     ':BLinesPrev<CR>', silent=true}
keymap.nnoremap{'<M-/>',     ':Lines<CR>',      silent=true}

keymap.nnoremap{'<leader>gg', ':GGrep<CR>',   silent=true}
keymap.nnoremap{'<leader>gf', ':GFiles<CR>',  silent=true}
keymap.nnoremap{'<leader>fh', ':History<CR>', silent=true}
keymap.nnoremap{'<leader>fl', silent=true, function()
    -- local term = vim.fn.input({prompt="Term: "})
    require('util').user_input{
        prompt = "Term: ",
        on_submit = function(term)
            local run = string.format("call fzf#vim#locate('%s', fzf#vim#with_preview())", term)
            vim.schedule(function()
                vim.cmd(run)
            end)
        end,
    }
end}

-- Replace the default dictionary completion with fzf-based fuzzy completion>
keymap.inoremap{'<c-x><c-k>', expr=true, [[fzf#vim#complete('cat /usr/share/dict/words-insane')]]}

-- Open the search tool.
keymap.nnoremap{"<leader>ff", ':ArshamRg<CR>'}
-- Search over current word.
keymap.nnoremap{"<leader>rg", [[:ArshamRg <C-R>=expand("<cword>")<CR><CR>]]}

keymap.nnoremap{'<leader>mm',  ":Marks<CR>"}
