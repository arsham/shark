return {
  "arsham/listish.nvim",
  name = "listish.nvim",
  dependencies = { "arshlib.nvim" },
  event = { "VeryLazy" },
  config = true,
  enabled = require("config.util").is_enabled("arsham/listish.nvim"),
}
