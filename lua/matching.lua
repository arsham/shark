local util = require('util')
require('astronauta.keymap')

local mappings = {
    { group = 'MatchingBrown'    , color = "#6D3717" },
    { group = 'MatchingPink'     , color = '#FF6188' },
    { group = 'MatchingGreen'    , color = '#A9DC76' },
    { group = 'MatchingAqua'     , color = '#78DCE8' },
    { group = 'MatchingYellow'   , color = '#FFD866' },
    { group = 'MatchingOrange'   , color = '#FC9867' },
    { group = 'MatchingPurple'   , color = '#AB9DF2' },
    { group = 'MatchingDarkred'  , color = 'darkred' },
    { group = 'MatchingRed'      , color = '#FD6883' },
    { group = 'MatchingBlue'     , color = '#1981F0' },
    { group = 'MatchingPaleblue' , color = '#6EABEC' },
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
vim.keymap.nnoremap{'<leader>mc', vim.fn.clearmatches}
