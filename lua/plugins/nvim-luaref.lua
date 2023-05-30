return {
  "milisims/nvim-luaref",
  ft = { "lua" },
  cond = require("config.util").should_start("milisims/nvim-luaref"),
  enabled = require("config.util").is_enabled("milisims/nvim-luaref"),
}
