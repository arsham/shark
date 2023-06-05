return {
  "arsham/yanker.nvim",
  name = "yanker.nvim",
  config = true,
  dependencies = {
    "arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  event = { "BufRead", "BufNewFile" },
  enabled = require("config.util").is_enabled("arsham/yanker.nvim"),
}
