return {
  "glts/vim-textobj-comment",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "kana/vim-textobj-user",
  },
  event = { "VeryLazy" },
  priority = 10,
}
