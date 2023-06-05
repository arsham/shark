return {
  "dhruvasagar/vim-zoom",
  keys = { { "<C-w>z", "<Plug>(zoom-toggle)" } },
  enabled = require("config.util").is_enabled("dhruvasagar/vim-zoom"),
}
