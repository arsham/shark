return {
  "stevearc/dressing.nvim",
  opts = {
    input = {
      default_prompt = "➤ ",
      insert_only = false,
      prefer_width = 100,
      min_width = 20,
    },

    win_options = {
      winblend = 0,
    },

    select = {
      backend = { "fzf_lua", "nui", "fzf", "builtin" },
      fzf_lua = {
        winopts = {
          width = 0.5,
          height = 0.5,
        },
      },
      fzf = {
        window = {
          width = 0.5,
          height = 0.5,
        },
      },
    },
  },
  event = { "VeryLazy" },
  cond = require("config.util").should_start("monaqa/dial.nvim"),
  enabled = require("config.util").is_enabled("monaqa/dial.nvim"),
  priority = 10,
}
