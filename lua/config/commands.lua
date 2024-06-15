local quick = require("arshlib.quick")
local constants = require("config.constants")
local augroup = require("config.util").augroup

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
  vim.api.nvim_set_option_value(
    "foldexp",
    "getline(v:lnum)=~'^\\s*'.&commentstring[0]",
    { scope = "local", win = 0 }
  )
  vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local", win = 0 })
end, { desc = "Fold comments by setting folf expr" }) --}}}

quick.command("Nowrap", function() --{{{
  vim.opt_local.formatoptions:remove({ "t", "c" })
end, { desc = "Stop wrapping current buffer" })
--}}}

quick.command("ToggleRelativeNumbers", function() --{{{
  local const = require("config.constants")
  vim.opt.relativenumber = const.disable_relative_numbers or false
  vim.opt.number = true
  const.disable_relative_numbers = not const.disable_relative_numbers
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

local get_clients = (
  vim.lsp.get_clients ~= nil and vim.lsp.get_clients -- nvim 0.10+
  or vim.lsp.get_active_clients
)

---Creates a new scratch buffer and puts the return value of the given fn in
---it.
---@param fn function(client: lspclient):string[]
local function show_lsp_caps(fn)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = get_clients({ bufnr = bufnr })

  local lines = {}
  for _, client in pairs(clients) do
    vim.list_extend(lines, fn(client))
  end

  require("config.scratch").new("markdown")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  quick.normal("x", "gg")
end

vim.api.nvim_create_user_command("LspCaps", function()
  show_lsp_caps(function(client)
    ---@cast client lspclient
    local lines = {}
    table.insert(lines, "# " .. client.name:upper())
    for key, value in pairs(client.server_capabilities) do
      if value and key:find("Provider") then
        local capability = key:gsub("Provider$", "")
        table.insert(lines, "- " .. capability)
      end
    end
    table.insert(lines, "")
    return lines
  end)
end, { desc = "Show short LSP servers capabilities in a scratch buffer" })

vim.api.nvim_create_user_command("LspCapsFull", function()
  show_lsp_caps(function(client)
    ---@cast client lspclient
    local lines = {}
    table.insert(lines, "# " .. client.name:upper())
    table.insert(lines, "```lua")
    local cap_lines = vim.inspect(client.server_capabilities)
    for s in cap_lines:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end
    table.insert(lines, "```")
    table.insert(lines, "")
    table.insert(lines, "")
    return lines
  end)
end, { desc = "Show full LSP servers capabilities in a scratch buffer" })

quick.command("Scratch", function(args)
  local ft = args.args
  if ft == "" then
    ft = "text"
  end
  require("config.scratch").new(ft)
end, { nargs = "?" })

vim.api.nvim_create_autocmd("Filetype", {
  group = augroup("go_mod_tidy.command"),
  pattern = "go,gomod",
  callback = function(args)
    local lsp = require("arshlib.lsp")
    quick.buffer_command("GoModTidy", function()
      local filename = vim.fn.expand("%:p")
      lsp.go_mod_tidy(tonumber(args.buf), filename)
    end, { desc = "Run go mod tidy on save" })
  end,
  desc = "Setup go mod tidy on go and go.mod files",
})

local tmuxp_store = false
local function start_completion(arg) --{{{
  local bktree = require("bk-tree")
  if not tmuxp_store then
    local projects = vim.fn.systemlist("tmuxp ls")
    tmuxp_store = bktree:new()
    for _, p in ipairs(projects) do
      tmuxp_store:insert(p)
    end
  end

  local ret = {}
  local max = 15
  if arg == "" then
    max = 100
  end
  local result = tmuxp_store:query(arg, max)
  for _, v in pairs(result) do
    table.insert(ret, v.str)
  end
  return ret
end --}}}

quick.command("Tmux", function(args) --{{{
  tmuxp_store = false
  require("plenary.job")
    :new({
      command = "tmuxp",
      args = { "load", "-y", args.args },
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          local res = table.concat(j:stderr_result(), "\n")
          vim.notify(res, vim.lsp.log_levels.ERROR, {
            title = "Loading project: " .. args.args,
            timeout = 5000,
          })
        end
      end,
    })
    :start()
end, { nargs = "+", complete = start_completion, desc = "load a tmuxp project" }) --}}}

quick.command("LazyLoadAll", function() --{{{
  local loader = require("lazy.core.loader")
  for _, plugin in pairs(require("lazy.core.config").plugins) do
    if not plugin._.loaded then
      loader.load(plugin, { start = "start" })
    end
  end
end, { desc = "Load all unloaded plugins. Only invoke for health checks" }) --}}}

quick.command("CC", function() --{{{
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = "close all floating buffers" }) --}}}

-- vim: fdm=marker fdl=0
