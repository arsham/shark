return {
  "MunifTanjim/nui.nvim",
  event = { "VeryLazy" },
  cond = require("config.util").should_start("MunifTanjim/nui.nvim"),
  enabled = require("config.util").is_enabled("MunifTanjim/nui.nvim"),
}
