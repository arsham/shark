return {
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
    cond = require("config.util").should_start("tpope/vim-repeat"),
    enabled = require("config.util").is_enabled("tpope/vim-repeat"),
  },
}
