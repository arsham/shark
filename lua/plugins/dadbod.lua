local function db_completion()
  require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
end

return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  config = function()
    vim.g.db_ui_save_location = vim.fn.expand("~/.config/dadbod")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
      },
      command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
        "mysql",
        "plsql",
      },
      callback = function()
        vim.schedule(db_completion)
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dbui" },
      callback = function()
        vim.keymap.set({ "n", "x" }, "<C-Space>", "<Plug>(DBUI_ExecuteQuery)")
      end,
    })
    vim.g.db_ui_table_helpers = {
      postgresql = {
        Count = 'select count(*) from "{table}"',
      },
    }
  end,
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
    "DBUIRenameBuffer",
    "DBUILastQueryInfo",
  },
  enabled = require("config.util").is_enabled("tpope/vim-dadbod"),
}
