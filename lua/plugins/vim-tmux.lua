return {
  "tmux-plugins/vim-tmux",
  ft = "tmux",
  cond = require("config.util").should_start("tmux-plugins/vim-tmux"),
  enabled = require("config.util").is_enabled("tmux-plugins/vim-tmux"),
}
