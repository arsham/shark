return {
  "arsham/indent-tools.nvim",
  name = "indent-tools.nvim",
  dependencies = {
    "arshlib.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  keys = { "]i", "[i", { mode = "v", "ii" }, { mode = "o", "ii" } },
  config = true,
  cond = require("config.util").should_start("arsham/indent-tools.nvim"),
  enabled = require("config.util").is_enabled("arsham/indent-tools.nvim"),
}
