return {
  "arsham/indent-tools.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  event = { "VeryLazy" },
  cond = require("util").full_start,
  config = true,
}
