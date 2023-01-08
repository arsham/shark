return {
  "bfredl/nvim-luadev",
  cmd = { "Luadev" },
  cond = require("util").full_start_with_lsp,
  -- stylua: ignore
  keys = {
    { mode = "n", "<leader>ll", "<Plug>(Luadev-RunLine)",     { silent = true, desc = "Execute the current line" }, },
    { mode = "n", "<leader>la", "<Plug>(Luadev-Run)",         { silent = true, desc = "Operator to execute lua code over a movement or text object." }, },
    { mode = "n", "<leader>le", "<Plug>(Luadev-RunWord)",     { silent = true, desc = "Eval identifier under cursor, including table.attr" }, },
    -- { mode = "n", "<leader>ll", "<Plug>(Luadev-Complete)", { silent = true, desc = "in insert mode: complete (nested) global table fields" }, },
  },
}
