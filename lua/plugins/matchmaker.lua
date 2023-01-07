return {
  "arsham/matchmaker.nvim",
  dependencies = {
    "arsham/arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  keys = { "<leader>me", "<leader>ma", "<leader>ml", "<leader>mp" },
  cond = require("util").full_start,
  config = true,
}
