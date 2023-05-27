return {
  "RaafatTurki/hex.nvim",
  config = true,
  cmd = { "HexToggle" },
  cond = require("config.util").should_start("RaafatTurki/hex.nvim"),
  enabled = require("config.util").is_enabled("RaafatTurki/hex.nvim"),
}
