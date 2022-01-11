local nvim = require("nvim")

vim.keymap.set("n", "<leader>v", function()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.opt_local.ve = "all"
    vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("v", "f", ":VBox<CR>", { buffer = true, noremap = true })
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
    return
  end

  vim.opt_local.ve = ""
  nvim.ex.mapclear("<buffer>")
  vim.b.venn_enabled = nil
end, { noremap = true })
