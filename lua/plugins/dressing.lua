return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
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
        backend = { "fzf_lua", "fzf", "nui", "builtin" },
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
    })
  end,
  event = { "VeryLazy" },
  enabled = require("util").full_start,
}
