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
  cond = require("config.util").should_start("andymass/vim-matchup"),
  enabled = require("config.util").is_enabled("andymass/vim-matchup"),
}
