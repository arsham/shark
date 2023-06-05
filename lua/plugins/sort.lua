return {
  "sQVe/sort.nvim",
  opts = {
    delimiters = { ",", "|", ";", ":", "s", "t" },
  },
  cmd = { "Sort" },
  enabled = require("config.util").is_enabled("sQVe/sort.nvim"),
}
