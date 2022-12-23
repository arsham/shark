return {
  "gbprod/substitute.nvim",
  config = function()
    require("substitute").setup({})

    local exchange = require("substitute.exchange")

    vim.keymap.set("n", "cx", function()
      exchange.operator()
    end, { noremap = true, desc = "exchange operator" })
    vim.keymap.set("n", "cxx", function()
      exchange.line()
    end, { noremap = true, desc = "exchange the line" })
    vim.keymap.set("x", "X", function()
      exchange.visual()
    end, { noremap = true, desc = "exchange operator" })
    vim.keymap.set("n", "cxc", function()
      exchange.cancel()
    end, { noremap = true, desc = "cancel exchange" })
  end,
  keys = { { "cx", "cxx", mode = "n" }, { "X", mode = "v" } },
}
