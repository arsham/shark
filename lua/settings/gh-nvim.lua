require("litee.lib").setup({
  tree = {
    icon_set = "nerd",
  },
  panel = {
    orientation = "left",
    panel_size = 30,
  },
  notify = {
    enabled = false,
  },
})

require("litee.lib").setup()
require("litee.gh").setup({
  icon_set = "nerd",
  refresh_interval = 60000, -- one minute
  keymaps = {
    open = "<CR>",
    expand = "zo", -- expand a collapsed node
    collapse = "zc", -- collpased an expanded node
    goto_issue = "gd",
    submit_comment = "<C-s>",
    actions = "<C-a>",
    resolve_thread = "<C-r>",
    goto_web = "gx",
    select = "<leader>ss",
    clear_selection = "<leader>sc",
    toggle_unread = "u",
  },
})
