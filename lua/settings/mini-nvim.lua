local quick = require("arshlib.quick")
quick.highlight("MiniTrailspace", { link = "ExtraWhitespace" })
quick.highlight("MiniSurround", { link = "Substitute" })
quick.highlight("MiniIndentscopeSymbol", { link = "VertSplit" })

require("mini.surround").setup({
  n_lines = 40,
  highlight_duration = 1000,

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
require("mini.indentscope").setup({
  draw = {
    delay = 100,
    animation = function()
      return 5
    end,
  },

  mappings = {
    object_scope = "",
    object_scope_with_border = "",
    goto_top = "",
    goto_bottom = "",
  },

  symbol = "╎",
})

require("mini.misc").setup({
  make_global = { "put", "put_text" },
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term:\\/\\/*",
  callback = function()
    vim.b.minicursorword_disable = true
  end,
  desc = "disable indentscope in terminal buffers",
}) --}}}
