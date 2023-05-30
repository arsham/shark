return {
  -- create ~/.gist-vim with this content: token xxxxx
  "mattn/vim-gist",
  dependencies = {
    { "mattn/webapi-vim", lazy = true },
  },
  config = function()
    vim.g.gist_per_page_limit = 100
  end,
  cmd = { "Gist" },
  cond = require("config.util").should_start("mattn/vim-gist"),
  enabled = require("config.util").is_enabled("mattn/vim-gist"),
}
