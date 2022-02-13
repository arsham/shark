local quick = require("arshlib.quick")
local nvim = require("nvim")

-- stylua: ignore start

quick.augroup({"SQLS_SETTINGS", {
  {"FileType", "sqls_output", function()
      vim.keymap.set("n", "q", nvim.ex.close, { noremap = true, buffer = true })
  end},
  {"FileType", "sql", function()
    vim.keymap.set("n", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { noremap = true, buffer = true, silent = true }
    )
    vim.keymap.set("v", "<C-Space>", ":SqlsExecuteQuery<CR>",
      { noremap = true, buffer = true, silent = true }
    )
  end}
}})

-- stylua: ignore end
