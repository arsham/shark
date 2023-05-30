return {
  "glts/vim-textobj-comment",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "kana/vim-textobj-user",
  },
  event = { "BufReadPost", "BufNewFile" },
  priority = 10,
  cond = require("config.util").should_start("numToStr/Comment.nvim"),
  enabled = require("config.util").is_enabled("numToStr/Comment.nvim"),
}
