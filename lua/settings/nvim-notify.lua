local notify = require("notify")
notify.setup({
  timeout = 3000,
})
vim.notify = notify
