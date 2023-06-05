return {
  "nvim-tree/nvim-web-devicons",
  event = { "UIEnter" },
  opts = {
    color_icons = true,
  },
  enabled = require("config.util").is_enabled("nvim-tree/nvim-web-devicons"),
}
