vim.opt_local.errorformat = require("config.errorformats").golangci
vim.opt_local.makeprg = "golangci-lint run ./..."
