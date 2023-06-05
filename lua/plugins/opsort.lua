return {
  "ralismark/opsort.vim",
  init = function()
    vim.g.opsort_no_mappings = true
  end,
  keys = {
    { mode = { "n", "x" }, "gso", "<plug>Opsort", { silent = true } },
    { mode = "n", "gsoo", "<plug>OpsortLines", { silent = true } },
  },
  enabled = require("config.util").is_enabled("ralismark/opsort.vim"),
}
