return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-git",
    "tpope/vim-rhubarb",
  },
  config = function()
    vim.g.fugitive_legacy_commands = 0
    vim.keymap.set("n", "<leader>gg", ":Git<cr>", { silent = true, desc = "Open fugitive" })
    vim.keymap.set(
      "n",
      "<leader>gd",
      ":Git diff %<cr>",
      { silent = true, desc = "View buffer's diff" }
    )
    local opts = {
      force = true,
      nargs = "*",
      desc = "Git log graph",
    }
    local command = "Git! lg <args>"
    vim.api.nvim_create_user_command("Glg", command, opts)
  end,
}
