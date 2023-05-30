return {
  "kiran94/s3edit.nvim",
  config = true,
  cmd = "S3Edit",
  cond = require("config.util").should_start("kiran94/s3edit.nvim"),
  enabled = require("config.util").is_enabled("kiran94/s3edit.nvim"),
}
