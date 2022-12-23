return {
  "dhruvasagar/vim-zoom",
  config = function()
    vim.keymap.set("n", "<C-W>z", "<Plug>(zoom-toggle)")
  end,
  keys = { "<C-w>z" },
}
