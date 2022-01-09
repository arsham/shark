local quick = require("arshlib.quick")

---Number pseudo-text object (integer and float) {{{
-- Exmaple: ciN
local function visual_number()
  vim.fn.search("\\d\\([^0-9\\.]\\|$\\)", "cW")
  quick.normal("x", "v")
  vim.fn.search("\\(^\\|[^0-9\\.]\\d\\)", "becW")
end
vim.keymap.set("x", "iN", visual_number, { noremap = true, desc = "in number" })
vim.keymap.set("o", "iN", visual_number, { noremap = true, desc = "in number" })
-- }}}

vim.keymap.set("o", "H", "^", { noremap = true, desc = "to the beginning of line" })
vim.keymap.set("o", "L", "$", { noremap = true, desc = "to the end of line" })

vim.keymap.set("v", "iz", function()
  quick.normal("xt", "[zjo]zk")
end, { noremap = true, silent = true, desc = "in fold block" })
vim.keymap.set("o", "iz", function()
  quick.normal("x", "viz")
end, { noremap = true, desc = "in fold block" })

vim.keymap.set("v", "az", function()
  quick.normal("xt", "[zo]z")
end, { noremap = true, silent = true, desc = "around fold block" })
vim.keymap.set("o", "az", function()
  quick.normal("x", "vaz")
end, { noremap = true, desc = "around fold block" })
-- stylua: ignore end

-- fdm=marker fdl=0
