return {
  "tmux-plugins/vim-tmux",
  ft = "tmux",
  enabled = require("config.util").is_enabled("tmux-plugins/vim-tmux"),
}
