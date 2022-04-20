local nvim = require("nvim")

-- stylua: ignore start
local sqls_settings_group = vim.api.nvim_create_augroup("SQLS_SETTINGS", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = sqls_settings_group,
  pattern = "sqls_output",
  callback = function()
    vim.keymap.set("n", "q", nvim.ex.close, { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = sqls_settings_group,
  pattern = "sql",
  callback = function()
    vim.keymap.set( "n", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { buffer = true, silent = true }
    )
    vim.keymap.set( "v", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { buffer = true, silent = true }
    )
  end,
})

-- stylua: ignore end
