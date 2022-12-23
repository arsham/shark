return {
  "nanotee/sqls.nvim",
  config = function()
    local sqls_settings_group = vim.api.nvim_create_augroup("SQLS_SETTINGS", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = sqls_settings_group,
      pattern = "sqls_output",
      callback = function()
        vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
      end,
    })
  end,
  dependencies = { "neovim/nvim-lspconfig" },
  ft = { "sql" },
  enabled = require("util").full_start_with_lsp,
}
