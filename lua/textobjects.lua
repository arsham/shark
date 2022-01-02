local util = require('util')

local function next_obj(motion)
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local step = 'l'
  if ch == ')' or ch == ']' or ch == '>' or ch == '}' then
    step = 'h'
  end
  local sequence = "f" .. ch .. step .. "v" .. motion .. ch
  util.normal('x', sequence)
end

util.xnoremap{'an', function()
  next_obj("a")
end, desc='around next pairs'}
util.onoremap{'an', function()
  next_obj("a")
end, desc='around next pairs'}
util.xnoremap{'in', function()
  next_obj("i")
end, desc='in next pairs'}
util.onoremap{'in', function()
  next_obj("i")
end, desc='in next pairs'}

--- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
--- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local chars = {'_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '-', '#' }
for _, char in ipairs(chars) do
  util.xnoremap{'i' .. char, function()
    util.normal('xt', 'T' .. char .. 'ot' .. char)
  end, desc='in pairs of ' .. char}
  util.onoremap{'i' .. char, function()
    util.normal('x', 'vi' .. char)
  end, desc='in pairs of ' .. char}
  util.xnoremap{'a' .. char, function()
    util.normal('xt', 'F' .. char .. 'of' .. char)
  end, desc='around pairs of ' .. char}
  util.onoremap{'a' .. char, function()
    util.normal('x', 'va' .. char)
  end, desc='around pairs of ' .. char}
end

---line pseudo text objects.
util.xnoremap{'il', function()
  util.normal('xt', 'g_o^')
end, desc='in current line'}
util.onoremap{'il', function()
  util.normal('x',  'vil')
end, desc='in current line'}
util.xnoremap{'al', function()
  util.normal('xt', '$o0')
end, desc='around current line'}
util.onoremap{'al', function()
  util.normal('x',  'val')
end, desc='around current line'}

---Number pseudo-text object (integer and float)
---Exmaple: ciN
local function visual_number()
  vim.fn.search('\\d\\([^0-9\\.]\\|$\\)', 'cW')
  util.normal('x', 'v')
  vim.fn.search('\\(^\\|[^0-9\\.]\\d\\)', 'becW')
end
util.xnoremap{'iN', visual_number, desc='in number'}
util.onoremap{'iN', visual_number, desc='in number'}

---Selects all lines with equal or higher indents to the current line in line
---visual mode. It ignores any empty lines.
local function in_indent()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local cur_indent = vim.fn.indent(cur_line)
  local total_lines = vim.api.nvim_buf_line_count(0)

  local first_line = cur_line
  for i = cur_line,0,-1 do
    if cur_indent == 0 and #vim.fn.getline(i) == 0 then
      --- If we are at column zero, we will stop at an empty line.
      break
    end
    if #vim.fn.getline(i) ~= 0 then
      local indent = vim.fn.indent(i)
      if indent < cur_indent then
        break
      end
    end
    first_line = i
  end

  local last_line = cur_line
  for i = cur_line,total_lines,1 do
    if cur_indent == 0 and #vim.fn.getline(i) == 0 then
      break
    end
    if #vim.fn.getline(i) ~= 0 then
      local indent = vim.fn.indent(i)
      if indent < cur_indent then
        break
      end
    end
    last_line = i
  end

  local sequence = string.format("%dgg0o%dgg$$", first_line, last_line)
  util.normal('xt', sequence)
end

util.vnoremap{'ii', in_indent, silent=true, desc='in indentation block'}
util.onoremap{'ii', function()
  util.normal('x', 'vii')
end, desc='in indentation block'}

---@param include boolean if true, will remove the backticks too.
local function in_backticks(include)
  util.normal('n', "m'")
  vim.fn.search('`', 'bcsW')
  local motion = ''
  if not include then
    motion = 'l'
  end

  util.normal('x', motion .. 'o')
  vim.fn.search('`', '')

  if include then return end
  util.normal('x', 'h')
end

util.vnoremap{'i`', function()
  in_backticks(false)
end,     silent = true, desc='in backticks'}
util.vnoremap{'a`', function()
  in_backticks(true)
end,      silent = true, desc='around backticks'}
util.onoremap{'i`', function()
  util.normal('x', 'vi`')
end, silent = true, desc='in backticks'}
util.onoremap{'a`', function()
  util.normal('x', 'va`')
end, silent = true, desc='around backticks'}

util.onoremap{'H', '^', desc='to the beginning of line'}
util.onoremap{'L', '$', desc='to the end of line'}

util.vnoremap{'iz', function()
  util.normal('xt', '[zjo]zk')
end, silent=true, desc='in fold block'}
util.onoremap{'iz', function()
  util.normal('x', 'viz')
end, desc='in fold block'}

util.vnoremap{'az', function()
  util.normal('xt', '[zo]z')
end, silent=true, desc='around fold block'}
util.onoremap{'az', function()
  util.normal('x', 'vaz')
end, desc='around fold block'}
