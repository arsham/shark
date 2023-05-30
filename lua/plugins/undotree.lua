return {
  "mbbill/undotree",
  branch = "search",
  init = function()
    vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
    vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
  end,
  cmd = { "UndotreeShow", "UndotreeToggle" },
  keys = {
    { mode = "n", "<leader>uu", ":UndotreeToggle<CR>", { silent = true } },
  },
  cond = require("config.util").should_start("mbbill/undotree"),
  enabled = require("config.util").is_enabled("mbbill/undotree"),
}
