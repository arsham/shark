return {
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
    enabled = require("config.util").is_enabled("tpope/vim-repeat"),
  },
}
