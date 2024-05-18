return {
  "rcarriga/nvim-notify",
  opts = {
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
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
  config = function(_, opts)
    local notify = require("notify")
    local nonicons_extention = require("nvim-nonicons.extentions.nvim-notify")
    opts.icons = nonicons_extention.icons
    notify.setup(opts)
    local quick = require("arshlib.quick")
    quick.command("NC", function()
      notify.dismiss({ silent = true, pending = true })
    end, { desc = "Close all notifications" })
  end,
  lazy = true,
  priority = 60,
  enabled = require("config.util").is_enabled("rcarriga/nvim-notify"),
}
