local nvim = require('nvim')
local util = require('util')
require('astronauta.keymap')

local M = {}

---When using `dd` in the quickfix list, remove the item from the quickfix
---list.
local function delete_list_item()
    local cur_list = {}
    local close = nvim.ex.close
    local win_id = vim.fn.win_getid()
    local is_loc = vim.fn.getwininfo(win_id)[1].loclist == 1

    if is_loc then
        cur_list = vim.fn.getloclist(win_id)
        close = nvim.ex.lclose
    else
        cur_list = vim.fn.getqflist()
    end

    local count = vim.v.count
    if count == 0 then count = 1 end
    if count > #cur_list then count = #cur_list end

    local item = vim.api.nvim_win_get_cursor(0)[1]
    for _ = item,item+count-1 do
        table.remove(cur_list, item)
    end

    if is_loc then
        vim.fn.setloclist(win_id, cur_list)
    else
        vim.fn.setqflist(cur_list)
    end

    if #cur_list == 0 then
        close()
    elseif item ~= 1 then
        util.normal('n', ("%dj"):format(item - 1))
    end
end

---@class ListItem
---@field bufnr number
---@field lnum number
---@field col number
---@field text string

---Inserts the current position of the cursor in the qf/local list with the
---note.
---@param item ListItem
---@param is_local boolean if true, the item goes into the local list.
function M.insert_list(item, is_local)
    local cur_list = {}
    if is_local then
        cur_list = vim.fn.getloclist(0)
    else
        cur_list = vim.fn.getqflist()
    end

    table.insert(cur_list, item)

    if is_local then
        vim.fn.setloclist(0, cur_list)
    else
        vim.fn.setqflist(cur_list)
    end
end

---Inserts the current position of the cursor in the qf/local list with the
---note.
---@param note string
---@param is_local boolean if true, the item goes into the local list.
local function inset_note_to_list(note, is_local)
    local location = vim.api.nvim_win_get_cursor(0)
    local item = {
        bufnr = vim.fn.bufnr(),
        lnum = location[1],
        col = location[2] + 1,
        text = note,
    }
    M.insert_list(item, is_local)
end

local clearqflist = function()
    vim.fn.setqflist({})
    nvim.ex.cclose()
end
local clearloclist = function()
    vim.fn.setloclist(0, {})
    nvim.ex.lclose()
end
util.command{"Clearquickfix", clearqflist}
util.command{"Clearloclist",  clearloclist}

---Opens a popup for a note, and adds the current line and column with the note
---to the list.
---@param name string the name of the mapping for repeating.
---@param is_local boolean if true, the item goes into the local list.
local function add_note(name, is_local)
    util.user_input{
        prompt = "Note: ",
        on_submit = function(value)
            inset_note_to_list(value, is_local)
            local key = vim.api.nvim_replace_termcodes(name, true, false, true)
            vim.fn["repeat#set"](key, vim.v.count)
        end,
    }
end

---Add the current line and the column to the list.
---@param name string the name of the mapping for repeating.
---@param is_local boolean if true, the item goes into the local list.
local function add_line(name, is_local)
    local note = vim.api.nvim_get_current_line()
    inset_note_to_list(note, is_local)
    local key = vim.api.nvim_replace_termcodes(name, true, false, true)
    vim.fn["repeat#set"](key, vim.v.count)
end

---Close quickfix list and local list windows.
vim.keymap.nnoremap{'<leader>cc', function()
    nvim.ex.cclose()
    nvim.ex.lclose()
end, silent=true}

---{{{ Quickfix list mappings
vim.keymap.nnoremap{'<leader>qo', nvim.ex.copen, silent=true}
vim.keymap.nnoremap{'<Plug>QuickfixAdd', function()
    add_line('<Plug>QuickfixAdd', false)
end}
vim.keymap.nmap{'<leader>qq', '<Plug>QuickfixAdd'}
vim.keymap.nnoremap{'<Plug>QuickfixNote', function()
    add_note('<Plug>QuickfixNote', false)
end}
vim.keymap.nmap{'<leader>qn', '<Plug>QuickfixNote'}
vim.keymap.nnoremap{'<leader>qc', clearqflist, silent=true}
---}}}

---{{{ Local list mappings
vim.keymap.nnoremap{'<leader>wo', nvim.ex.lopen, silent=true}
vim.keymap.nnoremap{'<Plug>LocallistAdd', function()
    add_line('<Plug>LocallistAdd', true)
end}
vim.keymap.nmap{'<leader>ww', '<Plug>LocallistAdd'}
vim.keymap.nnoremap{'<Plug>LocallistNote', function()
    add_note('<Plug>LocallistNote', true)
end}
vim.keymap.nmap{'<leader>wn', '<Plug>LocallistNote'}
vim.keymap.nnoremap{'<leader>wc', clearloclist, silent=true}
---}}}

---Creates a mapping for jumping through lists.
---@param key string the key to map.
---@param next string the command to execute if there is a next item.
---@param wrap string the command to execute if there is no next item.
local function jump_list_mapping(key, next, wrap)
    vim.keymap.nnoremap{key, function()
        util.cmd_and_centre(([[
            try
                %s
            catch /^Vim\%%((\a\+)\)\=:E553/
                %s
            catch /^Vim\%%((\a\+)\)\=:E42\|E776/
            endtry
        ]]):format(next, wrap))
    end}
end
jump_list_mapping(']q', 'cnext',     'cfirst')
jump_list_mapping('[q', 'cprevious', 'clast')
jump_list_mapping(']w', 'lnext',     'lfirst')
jump_list_mapping('[w', 'lprevious', 'llast')

util.augroup{"QF_LOC_LISTS", {
    {"Filetype", "qf", docs="don't list qf/local lists", run=function()
        vim.bo.buflisted = false
    end},
    {"FileType", "qf", docs="delete from qf/local lists", run=function()
        vim.keymap.nnoremap{'dd', delete_list_item, buffer=true}
    end},
}}

---Makes the quickfix and local list prettier. Borrowed from nvim-bqf.
function _G.qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = vim.fn.getqflist({id = info.id, items = 0}).items
    else
        items = vim.fn.getloclist(info.winid, {id = info.id, items = 0}).items
    end
    local limit = 40
    local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local valid_fmt = '%s │%5d:%-3d│%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ''
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = vim.fn.bufname(e.bufnr)
                if fname == '' then
                    fname = '[No Name]'
                else
                    fname = fname:gsub('^' .. vim.env.HOME, '~')
                end
                if #fname <= limit then
                    fname = fname_fmt1:format(fname)
                else
                    fname = fname_fmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = valid_fmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

vim.o.qftf = '{info -> v:lua.qftf(info)}'

return M
