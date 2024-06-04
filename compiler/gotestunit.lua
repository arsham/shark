vim.opt_local.errorformat = require("config.errorformats").go_with_testify
vim.opt_local.makeprg = "go test -test.fullpath ./..."
