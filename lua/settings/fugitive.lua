vim.keymap.set("n", "<leader>gg", ":Git<cr>", { silent = true, desc = "open fugitive" })
local opts = {
  force = true,
  nargs = "*",
  desc = "Git log graph",
}
local command = "Git! lg <args>"
vim.api.nvim_create_user_command("Glg", command, opts)
