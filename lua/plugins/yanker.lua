return {
  "arsham/yanker.nvim",
  config = function()
    require("yanker").config({})
  end,
  dependencies = {
    "arsham/arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  event = { "VeryLazy" },
  cond = require("util").full_start,
}
