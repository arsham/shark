return {
  "nvim-tree/nvim-web-devicons",
  event = { "UIEnter" },
  opts = {
    color_icons = true,
  },
  cond = require("config.util").should_start("nvim-tree/nvim-web-devicons"),
  enabled = require("config.util").is_enabled("nvim-tree/nvim-web-devicons"),
}
