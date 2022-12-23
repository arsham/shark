local function config()
  vim.keymap.set(
    "n",
    "<leader>ll",
    "<Plug>(Luadev-RunLine)",
    { silent = true, desc = "Execute the current line" }
  )
  vim.keymap.set(
    "n",
    "<leader>la",
    "<Plug>(Luadev-Run)",
    { silent = true, desc = "Operator to execute lua code over a movement or text object." }
  )
  vim.keymap.set(
    "n",
    "<leader>le",
    "<Plug>(Luadev-RunWord)",
    { silent = true, desc = "Eval identifier under cursor, including table.attr" }
  )
  -- vim.keymap.set(
  --   "<leader>ll",
  --   "<Plug>(Luadev-Complete)",
  --   { silent = true, desc = "in insert mode: complete (nested) global table fields" }
  -- )
end

return {
  "bfredl/nvim-luadev",
  config = config,
  cmd = { "Luadev" },
  enabled = require("util").full_start_with_lsp,
}
