local quick = require("arshlib.quick")
local nvim = require("nvim")

-- stylua: ignore start

quick.augroup("SQLS_SETTINGS", {
  { events = "FileType", pattern = "sqls_output", callback = function()
      vim.keymap.set("n", "q", nvim.ex.close, { noremap = true, buffer = true })
  end},
  { events = "FileType", pattern = "sql", callback = function()
    vim.keymap.set("n", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { noremap = true, buffer = true, silent = true }
    )
    vim.keymap.set("v", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { noremap = true, buffer = true, silent = true }
    )
  end},
})

-- stylua: ignore end
