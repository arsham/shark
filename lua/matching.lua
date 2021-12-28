local util = require('util')
require('astronauta.keymap')

local mappings = _t{
    { group = 'MatchingAA', color = '#FF6188' },
    { group = 'MatchingAB', color = '#A9DC76' },
    { group = 'MatchingAC', color = '#78DCE8' },
    { group = 'MatchingAD', color = '#FFD866' },
    { group = 'MatchingAE', color = '#FC9867' },
    { group = 'MatchingAF', color = '#AB9DF2' },
    { group = 'MatchingAG', color = 'darkred' },
    { group = 'MatchingAH', color = '#FD6883' },
    { group = 'MatchingAI', color = '#1981F0' },
    { group = 'MatchingAJ', color = '#6EABEC' },
    { group = 'MatchingAK', color = '#9261E2' },
    { group = 'MatchingAL', color = '#E261AB' },
    { group = 'MatchingAM', color = '#B7FC4F' },
    { group = 'MatchingAN', color = '#4FD9FC' },
    { group = 'MatchingAO', color = '#F9D9B7' },
    { group = 'MatchingAP', color = '#F9B7F9' },
    { group = 'MatchingAQ', color = '#006400' },
    { group = 'MatchingAR', color = '#008000' },
    { group = 'MatchingAS', color = '#008080' },
    { group = 'MatchingAT', color = '#008B8B' },
    { group = 'MatchingAU', color = '#00BFFF' },
    { group = 'MatchingAV', color = '#00CED1' },
    { group = 'MatchingAW', color = '#00FA9A' },
    { group = 'MatchingAX', color = '#00FF00' },
    { group = 'MatchingAY', color = '#00FF7F' },
    { group = 'MatchingAZ', color = '#00FFFF' },
    { group = 'MatchingBA', color = '#1E90FF' },
    { group = 'MatchingBB', color = '#20B2AA' },
    { group = 'MatchingBC', color = '#228B22' },
    { group = 'MatchingBD', color = '#2E8B57' },
    { group = 'MatchingBE', color = '#2F4F4F' },
    { group = 'MatchingBF', color = '#32CD32' },
    { group = 'MatchingBG', color = '#3CB371' },
    { group = 'MatchingBH', color = '#40E0D0' },
    { group = 'MatchingBI', color = '#4169E1' },
    { group = 'MatchingBJ', color = '#4682B4' },
    { group = 'MatchingBK', color = '#483D8B' },
    { group = 'MatchingBL', color = '#48D1CC' },
    { group = 'MatchingBM', color = '#4B0082' },
    { group = 'MatchingBN', color = '#556B2F' },
    { group = 'MatchingBO', color = '#5F9EA0' },
    { group = 'MatchingBP', color = '#6495ED' },
    { group = 'MatchingBQ', color = '#66CDAA' },
    { group = 'MatchingBR', color = '#696969' },
    { group = 'MatchingBS', color = '#6A5ACD' },
    { group = 'MatchingBT', color = '#6B8E23' },
    { group = 'MatchingBU', color = '#708090' },
    { group = 'MatchingBV', color = '#778899' },
    { group = 'MatchingBW', color = '#7B68EE' },
    { group = 'MatchingBX', color = '#87CEFA' },
    { group = 'MatchingBY', color = '#87CEEB' },
    { group = 'MatchingBZ', color = '#00BFFF' },
    { group = 'MatchingCA', color = '#2F4F4F' },
    { group = 'MatchingCB', color = '#48D1CC' },
    { group = 'MatchingCC', color = '#20B2AA' },
    { group = 'MatchingCD', color = '#5F9EA0' },
    { group = 'MatchingCE', color = '#008B8B' },
    { group = 'MatchingCF', color = '#008080' },
    { group = 'MatchingCG', color = '#7FFFD4' },
    { group = 'MatchingCH', color = '#90EE90' },
    { group = 'MatchingCI', color = '#98FB98' },
    { group = 'MatchingCJ', color = '#8FBC8F' },
    { group = 'MatchingCK', color = '#7CFC00' },
    { group = 'MatchingCL', color = '#7FFF00' },
    { group = 'MatchingCM', color = '#ADFF2F' },
    { group = 'MatchingCN', color = '#00FF7F' },
    { group = 'MatchingCO', color = '#00FA9A' },
    { group = 'MatchingCP', color = '#32CD32' },
    { group = 'MatchingCQ', color = '#9ACD32' },
    { group = 'MatchingCR', color = '#808000' },
    { group = 'MatchingCS', color = '#556B2F' },
    { group = 'MatchingCT', color = '#7FFF00' },
    { group = 'MatchingCU', color = '#ADFF2F' },
    { group = 'MatchingCV', color = '#00FF7F' },
    { group = 'MatchingCW', color = '#00FA9A' },
    { group = 'MatchingCX', color = '#32CD32' },
    { group = 'MatchingCY', color = '#9ACD32' },
    { group = 'MatchingCZ', color = '#808000' },
    { group = 'MatchingDA', color = '#556B2F' },
    { group = 'MatchingDB', color = '#7FFF00' },
    { group = 'MatchingDC', color = '#ADFF2F' },
    { group = 'MatchingDD', color = '#00FF7F' },
    { group = 'MatchingDE', color = '#00FA9A' },
    { group = 'MatchingDF', color = '#32CD32' },
    { group = 'MatchingDG', color = '#9ACD32' },
    { group = 'MatchingDH', color = '#808000' },
    { group = 'MatchingDI', color = '#556B2F' },
    { group = 'MatchingDJ', color = '#7FFF00' },
}

mappings:shuffle()

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

local function do_match(name, exact)
    local term = vim.fn.expand("<cword>")
    if exact then
        term = "\\<" .. term .. "\\>"
    end
    vim.fn.matchadd(next_group(), term)
    local key = vim.api.nvim_replace_termcodes(name, true, false, true)
    vim.fn["repeat#set"](key, vim.v.count)
end

---Add any matches containing a word under the cursor.
vim.keymap.nnoremap{'<Plug>MatchAdd', function()
    do_match('<Plug>MatchAdd', false)
end}
vim.keymap.nmap{'<leader>ma', '<Plug>MatchAdd'}

---Add any exact matches containing a word under the cursor.
vim.keymap.nnoremap{'<Plug>MatchExact', function()
    do_match('<Plug>MatchExact', true)
end}
vim.keymap.nmap{'<leader>me', '<Plug>MatchExact'}

---Add any matches containing the input from user.
vim.keymap.nnoremap{'<leader>mp', function()
    util.user_input{
        prompt = "Pattern: ",
        on_submit = function(term)
            vim.fn.matchadd(next_group(), term)
        end,
    }
end}

---Clear all matches of the current buffer.
vim.keymap.nnoremap{'<leader>mc', function()
    local groups = {}
    for _, v in ipairs(mappings) do
        groups[v.group] = true
    end

    local matches = vim.fn.getmatches()
    for id in ipairs(matches) do
        local v = matches[id]
        if v and groups[v.group] then
            vim.fn.matchdelete(v.id)
        end
    end
end}

---List all matches and remove by user's selection.
vim.keymap.nnoremap{'<leader>md', function()
    local source = _t()
    local groups = _t()
    mappings:map(function(v)
        groups[v.group] = v.color
    end)

    _t(vim.fn.getmatches())
    :filter(function(v)  return v and groups[v.group] end)
    :sort(function(a, b) return a.id > b.id end)
    :map(function(v)
        local str = string.format('%2d\t%50s\t%20s', v.id, v.pattern, groups[v.group])
        table.insert(source, str)
    end)

    if source:length() == 0 then return end

    local wrap = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--multi',
            '--bind', 'ctrl-a:select-all+accept ',
            '--layout reverse-list',
            '--delimiter="\t"',
            '--with-nth=2..',
        }, ' '),
    })
    wrap["sink*"] = function(list)
        for _, name in pairs(list) do
            local id = string.match(name, '^%s*(%d+)')
            if id ~= nil then
                vim.fn.matchdelete(id)
            end
        end
    end
    vim.fn["fzf#run"](wrap)
end}
