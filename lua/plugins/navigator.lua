return {
  "numToStr/Navigator.nvim",
  config = true,
  -- stylua: ignore
  keys = {
    { mode = "n", "<C-h>", function() require("Navigator").left() end,  { silent = true, desc = "Navigate to left window or tmux pane" } },
    { mode = "n", "<C-k>", function() require("Navigator").up() end,    { silent = true, desc = "Navigate to upper window or tmux pane" } },
    { mode = "n", "<C-l>", function() require("Navigator").right() end, { silent = true, desc = "Navigate to right window or tmux pane" } },
    { mode = "n", "<C-j>", function() require("Navigator").down() end,  { silent = true, desc = "Navigate to lower window or tmux pane" } },
  },
  enabled = require("config.util").is_enabled("numToStr/Navigator.nvim"),
}
