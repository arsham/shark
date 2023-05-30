return {
  "sQVe/sort.nvim",
  opts = {
    delimiters = { ",", "|", ";", ":", "s", "t" },
  },
  cmd = { "Sort" },
  cond = require("config.util").should_start("sQVe/sort.nvim"),
  enabled = require("config.util").is_enabled("sQVe/sort.nvim"),
}
