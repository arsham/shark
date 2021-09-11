local util = require('util')
require('astronauta.keymap')

local mappings = {
    { group = 'MatchingA', color = "#6D3717" },
    { group = 'MatchingB', color = '#FF6188' },
    { group = 'MatchingC', color = '#A9DC76' },
    { group = 'MatchingD', color = '#78DCE8' },
    { group = 'MatchingE', color = '#FFD866' },
    { group = 'MatchingF', color = '#FC9867' },
    { group = 'MatchingG', color = '#AB9DF2' },
    { group = 'MatchingH', color = 'darkred' },
    { group = 'MatchingI', color = '#FD6883' },
    { group = 'MatchingJ', color = '#1981F0' },
    { group = 'MatchingK', color = '#6EABEC' },
    { group = 'MatchingL', color = '#9261E2' },
    { group = 'MatchingM', color = '#E261AB' },
    { group = 'MatchingN', color = '#B7FC4F' },
    { group = 'MatchingO', color = '#4FD9FC' },
}

for _, mapping in pairs(mappings) do
    util.highlight(mapping['group'], {
        guifg = '#232627',
        guibg = mapping['color'],
        style = 'bold',
    })
end

local last_group = 0
local function next_group()
    last_group = last_group + 1
    if last_group > #mappings then last_group = 1 end
    return mappings[last_group]['group']
end

-- Add any matches containing a word under the cursor.
vim.keymap.nnoremap{'<leader>ma', function()
    local term = vim.fn.expand("<cword>")
    vim.fn.matchadd(next_group(), term)
end}

-- Add any exact matches containing a word under the cursor.
vim.keymap.nnoremap{'<leader>me', function()
    local term = "\\<" .. vim.fn.expand("<cword>") .. "\\>"
    vim.fn.matchadd(next_group(), term)
end}

-- Add any matches containing the input from user.
vim.keymap.nnoremap{'<leader>mp', function()
    util.user_input{
        prompt = "Pattern: ",
        on_submit = function(term)
            vim.fn.matchadd(next_group(), term)
        end,
    }
end}

-- Clear all matches of the current buffer.
vim.keymap.nnoremap{'<leader>mc', vim.fn.clearmatches}
