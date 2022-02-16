local dial = require("dial")

dial.augends["custom#boolean"] = dial.common.enum_cyclic({
  name = "boolean",
  strlist = { "true", "false" },
})

dial.augends["custom#weekday"] = dial.common.enum_cyclic({
  name = "weekday",
  strlist = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
})

dial.augends["custom#go#integer"] = dial.common.enum_cyclic({
  name = "integet",
  strlist = { "int", "int64", "int32" },
})

dial.augends["custom#go#float"] = dial.common.enum_cyclic({
  name = "float",
  strlist = { "float64", "float32" },
})

vim.list_extend(dial.config.searchlist.normal, {
  "char#alph#capital#str",
  "char#alph#capital#word",
  "char#alph#small#str",
  "char#alph#small#word",
  "color#hex",
  "date#[%H:%M]",
  "date#[%H:%M:%S]",
  "date#[%ja]",
  "date#[%jA]",
  "date#[%-m/%-d]",
  "date#[%m/%d]",
  "date#[%Y-%m-%d]",
  "date#[%Y/%m/%d]",
  "markup#markdown#header",
  "number#binary",
  "number#decimal",
  "number#decimal#fixed#space",
  "number#decimal#fixed#zero",
  "number#decimal#int",
  "number#hex",
  "number#octal",
  -- custom augends
  "custom#boolean",
  "custom#weekday",
  "custom#go#integer",
  "custom#go#float",
})

vim.keymap.set("n", "<C-a>", "<Plug>(dial-increment)", { silent = true })
vim.keymap.set("n", "<C-x>", "<Plug>(dial-decrement)", { silent = true })
vim.keymap.set("v", "<C-a>", "<Plug>(dial-increment)", { silent = true })
vim.keymap.set("v", "<C-x>", "<Plug>(dial-decrement)", { silent = true })
vim.keymap.set("v", "g<C-a>", "<Plug>(dial-increment-additional)", { silent = true })
vim.keymap.set("v", "g<C-x>", "<Plug>(dial-decrement-additional)", { silent = true })
