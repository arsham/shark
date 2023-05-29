return {
  "rbong/vim-flog",
  dependencies = { "tpope/vim-fugitive" },
  cmd = { "Flog", "Flogsplit" },
  init = function()
    vim.g.flog_default_opts = { max_count = 2000, all = true }
  end,
  cond = require("config.util").should_start("rbong/vim-flog"),
  enabled = require("config.util").is_enabled("rbong/vim-flog"),
}
