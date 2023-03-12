return {
  "arsham/indent-tools.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  cond = require("util").full_start,
  config = true,
}
