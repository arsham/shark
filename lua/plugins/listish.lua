return {
  "arsham/listish.nvim",
  name = "listish.nvim",
  dependencies = {
    "arshlib.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = true,
  enabled = require("config.util").is_enabled("arsham/listish.nvim"),
}
