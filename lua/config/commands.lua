local quick = require("arshlib.quick")

quick.command("Filename", function() --{{{
  vim.notify(vim.fn.expand("%:p"), vim.lsp.log_levels.INFO, {
    title = "Filename",
    timeout = 3000,
  })
end)
quick.command("YankFilename", function()
  vim.fn.setreg('"', vim.fn.expand("%:t"))
end)
quick.command("YankFilenameC", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end)
quick.command("YankFilepath", function()
  vim.fn.setreg('"', vim.fn.expand("%:p"))
end)
quick.command("YankFilepathC", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end) --}}}

quick.command("Nowrap", function() --{{{
  vim.opt_local.formatoptions:remove({ "t", "c" })
end, { desc = "Stop wrapping current buffer" })
--}}}

quick.command("ToggleRelativeNumbers", function() --{{{
  vim.opt.relativenumber = vim.g.disable_relative_numbers or false
  vim.opt.number = true
  vim.g.disable_relative_numbers = not vim.g.disable_relative_numbers
end, { desc = "Stop/Start switching relative numbers" })
--}}}
