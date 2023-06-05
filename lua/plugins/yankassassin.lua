return {
  "svban/YankAssassin.vim",
  event = { "BufRead", "BufNewFile" },
  enabled = require("config.util").is_enabled("svban/YankAssassin.vim"),
}
