return {
  "arsham/archer.nvim",
  name = "archer.nvim",
  dependencies = { "arshlib.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    textobj = {
      last_changed = { "ix", "ax" },
      context = { "iC", "aC" },
    },
  },
  cond = require("config.util").should_start("arsham/archer.nvim"),
  enabled = require("config.util").is_enabled("arsham/archer.nvim"),
}
