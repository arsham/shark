return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      timeout = 3000,
      render = "compact",
    })
    vim.notify = notify
  end,
  event = { "VeryLazy" },
  priority = 60,
}
