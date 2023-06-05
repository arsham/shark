return {
  "andymass/vim-matchup",
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {}
  end,
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.matchup = {
        enable = true,
      }
    end,
  },
  enabled = require("config.util").is_enabled("andymass/vim-matchup"),
}
