local nvim = require("nvim")
local util = require("util")

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
  if count == 0 then
    count = 1
  end
  if count > #cur_list then
    count = #cur_list
  end

  local item = vim.api.nvim_win_get_cursor(0)[1]
  for _ = item, item + count - 1 do
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
    util.normal("n", ("%dj"):format(item - 1))
  end
end

---@class ListItem
---@field bufnr number
---@field lnum number
---@field col number
---@field text string

---Inserts the current position of the cursor in the qf/local list with the
---note.
---@param items ListItem[]
---@param is_local boolean if true, the item goes into the local list.
function M.insert_list(items, is_local)
  local cur_list = {}
  if is_local then
    cur_list = vim.fn.getloclist(0)
  else
    cur_list = vim.fn.getqflist()
  end

  cur_list = vim.list_extend(cur_list, items)

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
  M.insert_list({ item }, is_local)
end

local clearqflist = function()
  vim.fn.setqflist({})
  nvim.ex.cclose()
end
local clearloclist = function()
  vim.fn.setloclist(0, {})
  nvim.ex.lclose()
end
util.command("Clearquickfix", clearqflist)
util.command("Clearloclist", clearloclist)

---Opens a popup for a note, and adds the current line and column with the note
---to the list.
---@param name string the name of the mapping for repeating.
---@param is_local boolean if true, the item goes into the local list.
local function add_note(name, is_local)
  util.user_input({
    prompt = "Note: ",
    on_submit = function(value)
      inset_note_to_list(value, is_local)
      local key = vim.api.nvim_replace_termcodes(name, true, false, true)
      vim.fn["repeat#set"](key, vim.v.count)
    end,
  })
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

-- stylua: ignore start
vim.keymap.set("n", "<leader>cc", function()
  nvim.ex.cclose()
  nvim.ex.lclose()
end, { noremap = true, silent = true, desc = "Close quickfix list and local list windows" })

--- Quickfix list mappings {{{
vim.keymap.set("n", "<leader>qo", nvim.ex.copen,
  { noremap = true, silent = true, desc = "open quickfix list" }
)

vim.keymap.set("n", "<Plug>QuickfixAdd", function()
  add_line("<Plug>QuickfixAdd", false)
end, { noremap = true, desc = "add to quickfix list" })

vim.keymap.set("n", "<leader>qq", "<Plug>QuickfixAdd",
  { noremap = true, desc = "add to quickfix list" }
)
vim.keymap.set("n", "<Plug>QuickfixNote", function()
  add_note("<Plug>QuickfixNote", false)
end, { noremap = true, desc = "add to quickfix list with a node" })

vim.keymap.set("n", "<leader>qn", "<Plug>QuickfixNote",
  { noremap = true, desc = "add to quickfix list with node" }
)
vim.keymap.set("n", "<leader>qd", clearqflist,
  { noremap = true, silent = true, desc = "drop quickfix list" }
)
vim.keymap.set("n", "<leader>qc", nvim.ex.cclose,
  { noremap = true, silent = true, desc = "close quickfix list" }
)
--- }}}

--- Local list mappings {{{
vim.keymap.set("n", "<leader>wo", nvim.ex.lopen,
  { noremap = true, silent = true, desc = "open local list" }
)
vim.keymap.set("n", "<Plug>LocallistAdd", function()
  add_line("<Plug>LocallistAdd", true)
end, { noremap = true, desc = "add to local list" })
vim.keymap.set("n", "<leader>ww", "<Plug>LocallistAdd",
  { noremap = true, desc = "add to local list" }
)
vim.keymap.set("n", "<Plug>LocallistNote", function()
  add_note("<Plug>LocallistNote", true)
end, { noremap = true, desc = "add to local list with a node" })
vim.keymap.set("n", "<leader>wn", "<Plug>LocallistNote",
  { noremap = true, desc = "add to local list with node" }
)
vim.keymap.set("n", "<leader>wd", clearloclist,
  { noremap = true, silent = true, desc = "drop local list" }
)
vim.keymap.set("n", "<leader>wc", nvim.ex.lclose,
  { noremap = true, silent = true, desc = "close local list" }
)
-- stylua: ignore end
--- }}}

---Creates a mapping for jumping through lists.
---@param key string the key to map.
---@param next string the command to execute if there is a next item.
---@param wrap string the command to execute if there is no next item.
---@param desc string the description of the mapping.
local function jump_list_mapping(key, next, wrap, desc)
  -- stylua: ignore
  vim.keymap.set("n", key, function()
    util.cmd_and_centre(([[
      try
        %s
      catch /^Vim\%%((\a\+)\)\=:E553/
        %s
      catch /^Vim\%%((\a\+)\)\=:E42\|E776/
      endtry
      ]]):format(next, wrap))
    end, {noremap=true, desc = desc }
  )
end
jump_list_mapping("]q", "cnext", "cfirst", "jump to next item in quickfix list")
jump_list_mapping("[q", "cprevious", "clast", "jump to previous item in quickfix list")
jump_list_mapping("]w", "lnext", "lfirst", "jump to next item in local list")
jump_list_mapping("[w", "lprevious", "llast", "jump to previous item in local list")

-- stylua: ignore start
util.augroup({"QF_LOC_LISTS", {
  {"Filetype", "qf", docs = "don't list qf/local lists", run = function()
    vim.bo.buflisted = false
    vim.opt_local.cursorline = true
  end},
  {"FileType", "qf", docs = "delete from qf/local lists", run = function()
    vim.keymap.set("n","dd", delete_list_item,{noremap=true, buffer = true, desc = "delete from qf/local lists", })
  end},
}})
-- stylua: ignore end

---Makes the quickfix and local list prettier. Borrowed from nvim-bqf.
-- selene: allow(global_usage)
function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 40
  local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
  local valid_fmt = "%s │%5d:%-3d│%s %s"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
        if #fname <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua.qftf(info)}"

return M
