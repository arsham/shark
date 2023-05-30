return {
  "smjonas/inc-rename.nvim",
  event = { "LspAttach" },
  opts = {
    cmd_name = "Rename",
  },
  cond = require("config.util").should_start("smjonas/inc-rename.nvim"),
  enabled = require("config.util").should_start("smjonas/inc-rename.nvim"),
}
