return {
  "tweekmonster/startuptime.vim",
  cmd = { "StartupTime" },
  cond = require("config.util").should_start("tweekmonster/startuptime.vim"),
  enabled = require("config.util").is_enabled("tweekmonster/startuptime.vim"),
}
