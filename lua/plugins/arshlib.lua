return {
  "arsham/arshlib.nvim",
  name = "arshlib.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  enabled = require("config.util").is_enabled("arsham/arshlib.nvim"),
}
