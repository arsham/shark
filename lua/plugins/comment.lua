return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = { { "gc", mode = { "n", "v" } } },
  opts = {
    pre_hook = function(ctx)
      return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
    end,
    enabled = require("config.util").is_enabled("numToStr/Comment.nvim"),
  },
}
