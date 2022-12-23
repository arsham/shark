return {
  "mbbill/undotree",
  branch = "search",
  config = function()
    vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
    vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
    vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { silent = true })
  end,
  cmd = { "UndotreeShow", "UndotreeToggle" },
  keys = { "<leader>u" },
}
