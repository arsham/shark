return {
  "ziontee113/color-picker.nvim",
  cmd = "PickColor",
  opts = {
    ["icons"] = { "ﱢ", "" },
  },

  cond = require("config.util").should_start("ziontee113/color-picker.nvim"),
  enabled = require("config.util").is_enabled("ziontee113/color-picker.nvim"),
}
