return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-git",
    "tpope/vim-rhubarb",
  },
  keys = {
    { mode = "n", "<leader>gg", ":Git<cr>", silent = true, desc = "Open fugitive" },
    { mode = "n", "<leader>gd", ":Git diff %<cr>", silent = true, desc = "View buffer's diff" },
  },
  lazy = false, -- otherwise starting directly into fugitive buffers would be empty.
  init = function()
    vim.g.fugitive_legacy_commands = 0
    local opts = {
      force = true,
      nargs = "*",
      desc = "Git log graph",
    }
    local command = "Git! lg <args>"
    vim.api.nvim_create_user_command("Glg", command, opts)

    vim.api.nvim_create_autocmd("FileType", {
      once = true,
      pattern = "fugitive",
      desc = "Fix fugitive startup empty buffer",
      callback = function()
        vim.schedule(function()
          vim.cmd("silent! e")
        end)
      end,
    })
  end,
}
