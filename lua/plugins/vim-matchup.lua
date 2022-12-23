return {
  "andymass/vim-matchup",
  config = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {}
  end,
  event = { "BufReadPost", "BufNewFile" },
  enabled = require("util").full_start,
}
