local quick = require("arshlib.quick")

---Number pseudo-text object (integer and float) {{{
-- Exmaple: ciN
local function visual_number()
  vim.fn.search("\\d\\([^0-9\\.]\\|$\\)", "cW")
  quick.normal("x", "v")
  vim.fn.search("\\(^\\|[^0-9\\.]\\d\\)", "becW")
end
vim.keymap.set("x", "iN", visual_number, { desc = "in number" })
vim.keymap.set("o", "iN", visual_number, { desc = "in number" })
-- }}}

vim.keymap.set("o", "H", "^", { desc = "to the beginning of line" })
vim.keymap.set("o", "L", "$", { desc = "to the end of line" })

vim.keymap.set("v", "iz", function()
  quick.normal("xt", "[zjo]zk")
end, { silent = true, desc = "in fold block" })
vim.keymap.set("o", "iz", function()
  quick.normal("x", "viz")
end, { desc = "in fold block" })

vim.keymap.set("v", "az", function()
  quick.normal("xt", "[zo]z")
end, { silent = true, desc = "around fold blocks" })
vim.keymap.set("o", "az", function()
  quick.normal("x", "vaz")
end, { desc = "around fold blocks" })

-- vim: fdm=marker fdl=0
