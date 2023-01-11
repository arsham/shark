return {
  "andymass/vim-matchup",
  lazy = true, -- we let treesitter manage this
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {}
  end,
  cond = require("util").full_start,
}
