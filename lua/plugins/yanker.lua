return {
  "arsham/yanker.nvim",
  config = true,
  dependencies = {
    "arsham/arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  event = { "VeryLazy" },
  cond = require("util").full_start,
}
