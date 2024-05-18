return {
  "arsham/indent-tools.nvim",
  name = "indent-tools.nvim",
  dependencies = {
    "arshlib.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  keys = {
    "]i",
    "[i",
    { mode = { "v", "x", "o" }, "ii" },
    { mode = { "v", "x", "o" }, "ai" },
  },
  config = true,
  enabled = require("config.util").is_enabled("arsham/indent-tools.nvim"),
}
