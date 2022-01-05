local nvim = require("nvim")
local util = require("util")

-- stylua: ignore
util.imap({ "<C-y>", [[copilot#Accept("\<CR>")]],
  silent = true, expr = true, script = true, desc = "copilot accept suggestion",
})
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
util.nnoremap({ "<leader>ce", ":Copilot enable<cr>", silent = true, desc = "enable copilot" })
util.nnoremap({ "<leader>cd", ":Copilot disable<cr>", silent = true, desc = "disable copilot" })
--- disabled by default
nvim.ex.Copilot("disable")
