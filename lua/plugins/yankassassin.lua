return {
  "svban/YankAssassin.vim",
  event = { "BufRead", "BufNewFile" },
  cond = require("config.util").should_start("svban/YankAssassin.vim"),
  enabled = require("config.util").is_enabled("svban/YankAssassin.vim"),
}
