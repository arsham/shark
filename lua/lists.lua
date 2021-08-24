local util = require('util')
require('astronauta.keymap')

local M = {}

-- When using `dd` in the quickfix list, remove the item from the quickfix
-- list.
local function delete_list_item()
    local cur_list = {}
    local close = "cclose"
    local win_id = vim.fn.win_getid()
    local is_loc = vim.fn.getwininfo(win_id)[1].loclist == 1

    if is_loc then
        cur_list = vim.fn.getloclist(win_id)
        close = "lclose"
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
        vim.cmd(close)
    elseif item ~= 1 then
        util.normal('n', ("%dj"):format(item - 1))
    end
end

-- Inserts the current position of the cursor in the qf/local list with the
-- note.
-- @param is_local(boolean): if true, the item goes into the local list.
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

-- Inserts the current position of the cursor in the qf/local list with the
-- note.
-- @param is_local(boolean): if true, the item goes into the local list.
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

util.command{"Clearquickfix", "call setqflist([]) | ccl"}
util.command{"Clearloclist",  "call setloclist(0, []) | lcl"}

local function add_note(is_local)
    return function()
        util.user_input{
            prompt = "Note: ",
            on_submit = function(value)
                inset_note_to_list(value, is_local)
            end,
        }
    end
end

local function add_line(is_local)
    return function()
        local note = vim.api.nvim_get_current_line()
        inset_note_to_list(note, is_local)
    end
end

vim.keymap.nnoremap{'<leader>qq', silent=true, add_line(false)}
vim.keymap.nnoremap{'<leader>qn', silent=true, add_note(false)}
vim.keymap.nnoremap{'<leader>qc', silent=true, ":Clearquickfix<CR>"}

vim.keymap.nnoremap{'<leader>ww', silent=true, add_line(true)}
vim.keymap.nnoremap{'<leader>wn', silent=true, add_note(true)}
vim.keymap.nnoremap{'<leader>wc', silent=true, ":Clearloclist<CR>"}

-- Creates a mapping for jumping through lists.
local function jump_list_mapping(key, next, wrap)
    vim.keymap.nnoremap{key, function()
        util.cmd_and_centre(([[
            try
                %s
            catch /^Vim\%%((\a\+)\)\=:E553/
                %s
            catch /^Vim\%%((\a\+)\)\=:E42/
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

return M
