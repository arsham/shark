local util = require("util")

-- stylua: ignore start
local function next_obj(motion)
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local step = "l"
  if ch == ")" or ch == "]" or ch == ">" or ch == "}" then
    step = "h"
  end
  local sequence = "f" .. ch .. step .. "v" .. motion .. ch
  util.normal("x", sequence)
end

vim.keymap.set("x", "an", function() next_obj("a") end, { noremap = true, desc = "around next pairs" })
vim.keymap.set("o", "an", function() next_obj("a") end, { noremap = true, desc = "around next pairs" })
vim.keymap.set("x", "in", function() next_obj("i") end, { noremap = true, desc = "in next pairs" })
vim.keymap.set("o", "in", function() next_obj("i") end, { noremap = true, desc = "in next pairs" })

--- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
--- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local chars = { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "-", "#" }
for _, char in ipairs(chars) do
  vim.keymap.set("x", "i" .. char, function()
    util.normal("xt", "T" .. char .. "ot" .. char)
  end, { noremap = true, desc = "in pairs of " .. char })
  vim.keymap.set("o", "i" .. char, function()
    util.normal("x", "vi" .. char)
  end, { noremap = true, desc = "in pairs of " .. char })
  vim.keymap.set("x", "a" .. char, function()
    util.normal("xt", "F" .. char .. "of" .. char)
  end, { noremap = true, desc = "around pairs of " .. char })
  vim.keymap.set("o", "a" .. char, function()
    util.normal("x", "va" .. char)
  end, { noremap = true, desc = "around pairs of " .. char })
end

---line pseudo text objects.
vim.keymap.set("x", "il", function() util.normal("xt", "g_o^") end, { noremap = true, desc = "in current line" })
vim.keymap.set("o", "il", function() util.normal("x", "vil") end, { noremap = true, desc = "in current line" })
vim.keymap.set("x", "al", function() util.normal("xt", "$o0") end, { noremap = true, desc = "around current line" })
vim.keymap.set("o", "al", function() util.normal("x", "val") end, { noremap = true, desc = "around current line" })

---Number pseudo-text object (integer and float)
---Exmaple: ciN
local function visual_number()
  vim.fn.search("\\d\\([^0-9\\.]\\|$\\)", "cW")
  util.normal("x", "v")
  vim.fn.search("\\(^\\|[^0-9\\.]\\d\\)", "becW")
end
vim.keymap.set("x", "iN", visual_number, { noremap = true, desc = "in number" })
vim.keymap.set("o", "iN", visual_number, { noremap = true, desc = "in number" })

---Selects all lines with equal or higher indents to the current line in line
---visual mode. It ignores any empty lines.
local function in_indent()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local cur_indent = vim.fn.indent(cur_line)
  local total_lines = vim.api.nvim_buf_line_count(0)

  local first_line = cur_line
  for i = cur_line, 0, -1 do
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
  for i = cur_line, total_lines, 1 do
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
  util.normal("xt", sequence)
end

vim.keymap.set("v", "ii", in_indent, { noremap = true, silent = true, desc = "in indentation block" })
vim.keymap.set("o", "ii", function() util.normal("x", "vii") end, { noremap = true, desc = "in indentation block" })

---@param include boolean if true, will remove the backticks too.
local function in_backticks(include)
  util.normal("n", "m'")
  vim.fn.search("`", "bcsW")
  local motion = ""
  if not include then
    motion = "l"
  end

  util.normal("x", motion .. "o")
  vim.fn.search("`", "")

  if include then
    return
  end
  util.normal("x", "h")
end

vim.keymap.set("v", "i`", function() in_backticks(false) end, { noremap = true, silent = true, desc = "in backticks" })
vim.keymap.set("v", "a`", function() in_backticks(true) end, { noremap = true, silent = true, desc = "around backticks" })
vim.keymap.set("o", "i`", function() util.normal("x", "vi`") end, { noremap = true, silent = true, desc = "in backticks" })
vim.keymap.set("o", "a`", function() util.normal("x", "va`") end, { noremap = true, silent = true, desc = "around backticks" })

vim.keymap.set("o", "H", "^", { noremap = true, desc = "to the beginning of line" })
vim.keymap.set("o", "L", "$", { noremap = true, desc = "to the end of line" })

vim.keymap.set("v", "iz", function() util.normal("xt", "[zjo]zk") end, { noremap = true, silent = true, desc = "in fold block" })
vim.keymap.set("o", "iz", function() util.normal("x", "viz") end, { noremap = true, desc = "in fold block" })

vim.keymap.set("v", "az", function() util.normal("xt", "[zo]z") end, { noremap = true, silent = true, desc = "around fold block" })
vim.keymap.set("o", "az", function() util.normal("x", "vaz") end, { noremap = true, desc = "around fold block" })
-- stylua: ignore end
