local quick = require("arshlib.quick")
local nvim = require("nvim")

vim.keymap.set(
  "n",
  "<C-Space>",
  ":SqlsExecuteQuery<CR>",
  { noremap = true, buffer = true, silent = true }
)
vim.keymap.set(
  "v",
  "<C-Space>",
  ":SqlsExecuteQuery<CR>",
  { noremap = true, buffer = true, silent = true }
)

quick.augroup({
  "SQLS_OUTPUT",
  {
    {
      "FileType",
      "sqls_output",
      function()
        vim.keymap.set("n", "q", nvim.ex.close, { noremap = true })
      end,
    },
  },
})
