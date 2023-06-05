return {
  "glts/vim-textobj-comment",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "kana/vim-textobj-user",
  },
  event = { "BufReadPost", "BufNewFile" },
  priority = 10,
  enabled = require("config.util").is_enabled("numToStr/Comment.nvim"),
}
