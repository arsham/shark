return {
  "andymass/vim-matchup",
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {}
  end,
  event = { "BufReadPost", "BufNewFile" },
  cond = require("util").full_start,
}
