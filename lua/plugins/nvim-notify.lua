return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      timeout = 3000,
      render = "compact",
      fps = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
      level = 2,
      minimum_width = 50,
      top_down = true,
    })
    vim.notify = notify
  end,
  event = { "VeryLazy" },
  priority = 60,
  enabled = require("config.util").is_enabled("rcarriga/nvim-notify"),
}
