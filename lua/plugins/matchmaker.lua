return {
  "arsham/matchmaker.nvim",
  name = "matchmaker.nvim",
  dependencies = {
    "arshlib.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
  },
  keys = { "<leader>me", "<leader>ma", "<leader>ml", "<leader>mp" },
  config = true,
  cond = require("config.util").should_start("arsham/matchmaker.nvim"),
  enabled = require("config.util").is_enabled("arsham/matchmaker.nvim"),
}
