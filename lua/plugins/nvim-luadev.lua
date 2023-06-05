return {
  "bfredl/nvim-luadev",
  cmd = { "Luadev" },
  -- stylua: ignore
  keys = {
    { mode = "n", "<leader>ll", "<Plug>(Luadev-RunLine)",     { silent = true, desc = "Execute the current line" }, },
    { mode = "n", "<leader>la", "<Plug>(Luadev-Run)",         { silent = true, desc = "Operator to execute lua code over a movement or text object." }, },
    { mode = "n", "<leader>le", "<Plug>(Luadev-RunWord)",     { silent = true, desc = "Eval identifier under cursor, including table.attr" }, },
  },
  enabled = require("config.util").is_enabled("bfredl/nvim-luadev"),
}
