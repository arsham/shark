local quick = require("arshlib.quick")

-- stylua: ignore start
local function next_obj(motion)--{{{
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local step = "l"
  if ch == ")" or ch == "]" or ch == ">" or ch == "}" then
    step = "h"
  end
  local sequence = "f" .. ch .. step .. "v" .. motion .. ch
  quick.normal("x", sequence)
end

vim.keymap.set("x", "an", function() next_obj("a") end, { noremap = true, desc = "around next pairs" })
vim.keymap.set("o", "an", function() next_obj("a") end, { noremap = true, desc = "around next pairs" })
vim.keymap.set("x", "in", function() next_obj("i") end, { noremap = true, desc = "in next pairs" })
vim.keymap.set("o", "in", function() next_obj("i") end, { noremap = true, desc = "in next pairs" })--}}}

-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a# {{{
local chars = { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "-", "#" }
for _, char in ipairs(chars) do
  vim.keymap.set("x", "i" .. char, function()
    quick.normal("xt", "T" .. char .. "ot" .. char)
  end, { noremap = true, desc = "in pairs of " .. char })
  vim.keymap.set("o", "i" .. char, function()
    quick.normal("x", "vi" .. char)
  end, { noremap = true, desc = "in pairs of " .. char })
  vim.keymap.set("x", "a" .. char, function()
    quick.normal("xt", "F" .. char .. "of" .. char)
  end, { noremap = true, desc = "around pairs of " .. char })
  vim.keymap.set("o", "a" .. char, function()
    quick.normal("x", "va" .. char)
  end, { noremap = true, desc = "around pairs of " .. char })
end
-- }}}
-- Line pseudo text objects {{{
vim.keymap.set("x", "il", function() quick.normal("xt", "g_o^") end, { noremap = true, desc = "in current line" })
vim.keymap.set("o", "il", function() quick.normal("x", "vil") end, { noremap = true, desc = "in current line" })
vim.keymap.set("x", "al", function() quick.normal("xt", "$o0") end, { noremap = true, desc = "around current line" })
vim.keymap.set("o", "al", function() quick.normal("x", "val") end, { noremap = true, desc = "around current line" })
-- }}}

---Number pseudo-text object (integer and float) {{{
-- Exmaple: ciN
local function visual_number()
  vim.fn.search("\\d\\([^0-9\\.]\\|$\\)", "cW")
  quick.normal("x", "v")
  vim.fn.search("\\(^\\|[^0-9\\.]\\d\\)", "becW")
end
vim.keymap.set("x", "iN", visual_number, { noremap = true, desc = "in number" })
vim.keymap.set("o", "iN", visual_number, { noremap = true, desc = "in number" })
-- }}}
-- Backtick support {{{
---@param include boolean if true, will remove the backticks too.
local function in_backticks(include)
  quick.normal("n", "m'")
  vim.fn.search("`", "bcsW")
  local motion = ""
  if not include then
    motion = "l"
  end

  quick.normal("x", motion .. "o")
  vim.fn.search("`", "")

  if include then
    return
  end
  quick.normal("x", "h")
end

vim.keymap.set("v", "i`", function() in_backticks(false) end, { noremap = true, silent = true, desc = "in backticks" })
vim.keymap.set("v", "a`", function() in_backticks(true) end, { noremap = true, silent = true, desc = "around backticks" })
vim.keymap.set("o", "i`", function() quick.normal("x", "vi`") end, { noremap = true, silent = true, desc = "in backticks" })
vim.keymap.set("o", "a`", function() quick.normal("x", "va`") end, { noremap = true, silent = true, desc = "around backticks" })
--}}}
vim.keymap.set("o", "H", "^", { noremap = true, desc = "to the beginning of line" })
vim.keymap.set("o", "L", "$", { noremap = true, desc = "to the end of line" })

vim.keymap.set("v", "iz", function() quick.normal("xt", "[zjo]zk") end, { noremap = true, silent = true, desc = "in fold block" })
vim.keymap.set("o", "iz", function() quick.normal("x", "viz") end, { noremap = true, desc = "in fold block" })

vim.keymap.set("v", "az", function() quick.normal("xt", "[zo]z") end, { noremap = true, silent = true, desc = "around fold block" })
vim.keymap.set("o", "az", function() quick.normal("x", "vaz") end, { noremap = true, desc = "around fold block" })
-- stylua: ignore end

-- fdm=marker fdl=0
