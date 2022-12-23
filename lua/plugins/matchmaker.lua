return {
  "arsham/matchmaker.nvim",
  dependencies = {
    "arsham/arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  config = function()
    require("matchmaker").config({})
  end,
  keys = { "<leader>me", "<leader>ma", "<leader>ml", "<leader>mp" },
  enabled = require("util").full_start,
}
