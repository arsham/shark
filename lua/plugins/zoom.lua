return {
  "dhruvasagar/vim-zoom",
  keys = { { "<C-w>z", "<Plug>(zoom-toggle)" } },
  cond = require("config.util").should_start("dhruvasagar/vim-zoom"),
  enabled = require("config.util").is_enabled("dhruvasagar/vim-zoom"),
}
