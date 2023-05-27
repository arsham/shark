return {
  "arsham/arshlib.nvim",
  name = "arshlib.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  cond = require("config.util").should_start("arsham/arshlib.nvim"),
  enabled = require("config.util").is_enabled("arsham/arshlib.nvim"),
}
