require("arshlib.quick").highlight("MiniTrailspace", { link = "ExtraWhitespace" })
require("arshlib.quick").highlight("MiniSurround", { link = "Substitute" })
require("arshlib.quick").highlight("MiniIndentscopeSymbol", { link = "VertSplit" })

require("mini.surround").setup({
  n_lines = 40,
  highlight_duration = 1000,
  funname_pattern = "[%w_%.]+",

  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
    find = "yf",
    find_left = "yF",
    highlight = "yh",
    update_n_lines = "yn",
  },
})

require("mini.trailspace").setup({})
require("mini.misc").setup({
  make_global = { "put", "put_text" },
})
