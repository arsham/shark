local util = require('util')
local nvim = require('nvim')

local store = {}
__Scratch_buffer_storage = __Scratch_buffer_storage or {}
store = __Scratch_buffer_storage

function store.next()
    local i = 1
    while true do
        if not store[i] then
            store[i] = true
            return i
        end
        i = i + 1
    end
end

function store.delete(id)
    store[id] = nil
end

util.command("Scratch", function()
    local name = string.format("Scratch %d", store.next())
    nvim.ex.vsplit()
    nvim.ex.enew()
    nvim.ex.file(name)
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false

    util.autocmd{"BufDelete", buffer=true, run=function()
        local num = tonumber(vim.fn.expand('<afile>'):match("Scratch (%d+)"))
        store.delete(num)
    end}
end)
