return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
          c = "// %s",
          go = "// %s",
          sql = "-- %s",
          lua = "-- %s",
          vim = '" %s',
        },
      }
    end,
  },
  cond = require("config.util").should_start("JoosepAlviste/nvim-ts-context-commentstring"),
  enabled = require("config.util").is_enabled("JoosepAlviste/nvim-ts-context-commentstring"),
}
