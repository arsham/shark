local util = require('util')

local store = _t()
__Clipboard_storage = __Clipboard_storage or _t()
store = __Clipboard_storage

util.augroup{"CLIPBOARD", {
  {"TextYankPost", "*", function()
    table.insert(store, 1, vim.v.event)
  end},
}}

---Lists all yank history, and will set it to the unnamed register on
---selection.
util.nnoremap{'<leader>yh', function()
  local yank_list = _t()
  local seen = _t()
  store:filter(function(v)
    local key = table.concat(v.regcontents, "\n"):gsub('%s+', '')
    if seen[key] then
      return false
    end
    seen[key] = true
    return true
  end)
  :map(function(v, i)
    local value = table.concat(v.regcontents, util.ansi_color(util.colours.blue, '<CR>'))
    local type = "BLOCK"
    if v.regtype == "v" then
      type = "visual"
    elseif v.regtype == "V" then
      type = "VISUAL"
    end
    table.insert(yank_list, string.format('%d\t%s\t%s', i, util.ansi_color(util.colours.green, type), value))
  end)

  if yank_list:length() == 0 then return end

  local wrapped = vim.fn["fzf#wrap"]({
    source = yank_list,
    options = table.concat({
      '--prompt "Preciously Yanked > "',
      '--ansi',
      '-d "\t"',
      '--with-nth 2..',
      '--nth 2,2..3',
    }, ' ')
  })
  wrapped["sink*"] = function(line)
    local index = string.gmatch(line[2], '%d+')()
    local item = store[tonumber(index)]
    local value = table.concat(item.regcontents, "\n")
    vim.fn.setreg('"', value, item.regtype)
  end
  vim.fn["fzf#run"](wrapped)
end, silent=true, desc='Show yank history'}
