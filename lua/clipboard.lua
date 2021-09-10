local util = require('util')
require('astronauta.keymap')

local store = {}
__Clipboard_storage = __Clipboard_storage or {}
store = __Clipboard_storage

util.augroup{"CLIPBOARD", {
    {"TextYankPost", "*", function()
        -- We are trying to make a set here, instead we will clean up when we
        -- read.
        table.insert(store, 1, vim.v.event)
    end},
}}

-- Removes duplicates from the store. We do this just when we list the items,
-- otherwise we have to spend too much time deduplicating everytime we yank
-- something.
local function make_unique()
    local unique = {}
    local seen = {}
    for _, v in pairs(store) do
        local key = table.concat(v.regcontents, "\n")
        if seen[key] == nil then
            seen[key] = true
            table.insert(unique, v)
        end
    end
    store = unique
end

-- Lists all yank history, and will set it to the unnamed register on
-- selection.
vim.keymap.nnoremap{'<leader>yh', silent=true, function()
    make_unique()
    local yank_list = {}
    for i, v in pairs(store) do
        local value = table.concat(v.regcontents, "\n")
        table.insert(yank_list, i .. '\t' .. value)
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = yank_list,
        options = '--prompt "Preciously Yanked > "',
    })
    wrapped["sink*"] = function(line)
        local index = string.gmatch(line[2], '%d+')()
        local item = store[tonumber(index)]
        local value = table.concat(item.regcontents, "\n")
        vim.fn.setreg('"', value, item.regtype)
    end
    vim.fn["fzf#run"](wrapped)
end}
