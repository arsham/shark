return {
  "numToStr/Navigator.nvim",
  config = true,
  -- stylua: ignore
  keys = {
    { mode = "n", "<C-h>", function() require("Navigator").left() end,  { silent = true, desc = "navigate to left window or tmux pane" } },
    { mode = "n", "<C-k>", function() require("Navigator").up() end,    { silent = true, desc = "navigate to upper window or tmux pane" } },
    { mode = "n", "<C-l>", function() require("Navigator").right() end, { silent = true, desc = "navigate to right window or tmux pane" } },
    { mode = "n", "<C-j>", function() require("Navigator").down() end,  { silent = true, desc = "navigate to lower window or tmux pane" } },
  },
}
