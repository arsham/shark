local quick = require("arshlib.quick")
local constants = require("config.constants")

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

quick.command("FoldComments", function() --{{{
  vim.wo.foldexpr = "getline(v:lnum)=~'^\\s*'.&commentstring[0]"
  vim.wo.foldmethod = "expr"
end, { desc = "Fold comments by setting folf expr" }) --}}}

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

quick.command("UnlinkSnippets", function() --{{{
  local ok, session = pcall(require, "luasnip.session")
  if not ok then
    return
  end
  local cur_buf = vim.api.nvim_get_current_buf()

  while true do
    local node = session.current_nodes[cur_buf]
    if not node then
      return
    end
    local user_expanded_snip = node.parent
    -- find 'outer' snippet.
    while user_expanded_snip.parent do
      user_expanded_snip = user_expanded_snip.parent
    end

    user_expanded_snip:remove_from_jumplist()
    -- prefer setting previous/outer insertNode as current node.
    session.current_nodes[cur_buf] = user_expanded_snip.prev.prev or user_expanded_snip.next.next
  end
end, { desc = "Unlink all open snippet sessions" })
--}}}

quick.command("ToggleTrimWhitespaces", function() -- {{{
  local name = constants.disable_trim_whitespace
  local set_to = true
  local ok, val = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok and val then
    set_to = false
  end
  vim.api.nvim_buf_set_var(0, name, set_to)
end, { desc = "toggle trimming whitespaces on current buffer" })
-- }}}

vim.api.nvim_create_user_command("EditConfig", function(opts)
  if opts.args == "" then
    vim.cmd("edit $MYVIMRC")
    return
  end

  local config_path = vim.fn.stdpath("config")
  local path = vim.fs.find({ opts.args .. ".lua" }, { path = config_path .. "/lua" })[1]
  if not path then
    vim.api.nvim_err_writeln(string.format("File %s.lua not found.", opts.args))
    return
  end

  vim.cmd("tabedit " .. path)
  vim.cmd("tcd " .. config_path)
end, {
  nargs = "?",
  complete = function(line)
    local paths = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua", "**/*.lua")
    local files = {}
    for file in paths:gmatch("([^\n]+)") do
      table.insert(files, file:match("^.+/(.+)%."))
    end

    return vim.tbl_filter(function(value)
      return vim.startswith(value, line)
    end, files)
  end,
  desc = "Edit configuration files in a new tab",
})

quick.command("Scratch", function(args)
  local ft = args.args
  if ft == "" then
    ft = "text"
  end
  require("config.scratch").new(ft)
end, { nargs = "?" })

-- vim: fdm=marker fdl=0
