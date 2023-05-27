return {
  "arsham/listish.nvim",
  name = "listish.nvim",
  dependencies = { "arshlib.nvim" },
  event = { "VeryLazy" },
  config = true,
  cond = require("config.util").should_start("arsham/listish.nvim"),
  enabled = require("config.util").is_enabled("arsham/listish.nvim"),
}
