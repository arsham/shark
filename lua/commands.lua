local fs = require("arshlib.fs")
local quick = require("arshlib.quick")

local M = {}

quick.command("Filename", function()
  vim.notify(vim.fn.expand("%:p"), vim.lsp.log_levels.INFO, {
    title = "Filename",
    timeout = 3000,
  })
end)
quick.command("YankFilename", function() --{{{
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

quick.command("MergeConflict", ":grep '<<<<<<< HEAD'")
quick.command("JsonDiff", [[vert ball | windo execute '%!gojq' | windo diffthis]])

---Sets up a watch on the filename if it is a lua module.
---@param filenames string[]
local function setup_watch(filenames) --{{{
  local modules = {}
  for _, filename in ipairs(filenames) do
    local mod, ok = fs.file_module(filename)

    if not ok then
      local msg = string.format("Could not figure out the package: %s", filename)
      vim.notify(msg, vim.lsp.log_levels.ERROR, {
        title = "Reload Error",
        timeout = 2000,
      })
    else
      table.insert(modules, mod)
    end
  end
  return modules
end --}}}

-- selene: allow(global_usage)
if not _G.watch_lua_file_group_set then --{{{
  vim.api.nvim_create_augroup("WATCH_LUA_FILE", { clear = true })
  _G.watch_lua_file_group_set = true
end --}}}

function M.watch_file_changes(filenames) --{{{
  local reloader = require("plenary.reload")
  local modules = setup_watch(filenames)
  local names = {}
  for _, module in ipairs(modules) do
    table.insert(names, module.name)
    local watched = module.name
    if string.find(watched, "/") then
      watched = "*/" .. watched
    end
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = "WATCH_LUA_FILE",
      pattern = watched,
      callback = function()
        for _, mod in ipairs(modules) do
          reloader.reload_module(mod.module, false)
          require(mod.module)
        end

        local msg = table.concat(names, "\n")
        vim.notify(msg, vim.lsp.log_levels.INFO, {
          title = "Reloaded",
          timeout = 1000,
        })
      end,
      desc = string.format("watching %s", module.name),
    })
  end

  local msg = table.concat(names, "\n")
  vim.notify(msg, vim.lsp.log_levels.INFO, {
    title = "Watching Changes",
    timeout = 2000,
  })
end --}}}

quick.command("WatchLuaFileChanges", function(arg) --{{{
  local filename = vim.fn.expand("%:p")
  local files = {}
  if arg and arg.args ~= "" then
    files = vim.split(arg.args, " ") or {}
  end
  table.insert(files, filename)
  M.watch_file_changes(files)
end, { nargs = "*", complete = "file" }) --}}}

quick.command("CC", function() --{{{
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end) --}}}

quick.command("FoldComments", function() --{{{
  vim.wo.foldexpr = [[getline(v:lnum)=~'^\s*//']]
  vim.wo.foldmethod = "expr"
end) --}}}

quick.command("Nowrap", function() --{{{
  vim.bo.formatoptions = vim.bo.formatoptions:gsub("t", "")
  vim.bo.formatoptions = vim.bo.formatoptions:gsub("c", "")
end) --}}}

quick.command("ToggleRelativeNumbers", function() --{{{
  vim.opt.relativenumber = vim.g.disable_relative_numbers or false
  vim.opt.number = true
  vim.g.disable_relative_numbers = not vim.g.disable_relative_numbers
end) --}}}

quick.command("InstallDependencies", function() --{{{
  local commands = _t({
    golangci = _t({
      "go",
      "install",
      "github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2",
    }),
    gojq = _t({ "go", "install", "github.com/itchyny/gojq/cmd/gojq@latest" }),
    sqls = _t({ "go", "install", "github.com/lighttiger2505/sqls@latest" }),
    fixjson = _t({ "npm", "-g", "install", "--prefix", "~/.node_modules", "fixjson@latest" }),
    prettier = _t({ "npm", "-g", "install", "--prefix", "~/.node_modules", "prettier@latest" }),
    neovim = _t({ "npm", "-g", "install", "--prefix", "~/.node_modules", "neovim@latest" }),
    selene = _t({ "cargo", "install", "selene" }),
    stylua = _t({ "cargo", "install", "stylua" }),
  })

  local total = commands:map_length()
  local count = 0

  local job = require("plenary.job")
  for name, spec in pairs(commands) do --{{{
    job
      :new({
        command = spec[1],
        args = spec:slice(2, #spec),
        on_exit = function(j, exit_code)
          local res = table.concat(j:result(), "\n")
          local type = vim.lsp.log_levels.INFO
          local timeout = 2000

          if exit_code ~= 0 then
            type = vim.lsp.log_levels.ERROR
            res = table.concat(j:stderr_result(), "\n")
            timeout = 10000
          end

          vim.notify(res, type, {
            title = name:title_case(),
            timeout = timeout,
          })

          count = count + 1
          if count == total then
            local str =
              "yay -S ripgrep bat words-insane ctags python-pip the_silver_searcher && snap install diagon"
            vim.schedule(function()
              vim.fn.setreg("+", str)
            end)
            local data = table.concat({
              "Please run:",
              "    " .. str,
              "",
              "The command has been yanked to your clickboard!",
            }, "\n")
            vim.notify(data, vim.lsp.log_levels.INFO, {
              title = "All done!",
              timeout = 3000,
            })
          end
        end,
      })
      :start()
  end --}}}
end, { desc = "Install shark's required dependencies" }) --}}}

local project_store = false
local function running_tmuxinator_projects() --{{{
  if project_store then
    return project_store
  end
  local tmux_sessions = vim.fn.systemlist("tmux list-sessions -F '#{session_name}'")
  local sessions = {}
  for _, name in ipairs(tmux_sessions) do
    local cmd = string.format("rg -l '%s$' %s/.config/tmuxinator/*.yml", name, vim.env.HOME)
    local session_file = vim.fn.system(cmd)
    if session_file ~= "" then
      sessions[vim.fn.fnamemodify(session_file, ":t:r")] = true
    end
  end
  project_store = sessions
  return sessions
end --}}}

local bktree = require("bk-tree")
local tmuxinator_store = false
---@param fn fun(v: string):boolean includes value if returns true
local function tm_completion(arg, fn) --{{{
  if not tmuxinator_store then
    local projects = vim.fn.systemlist("tmuxinator completions start")
    tmuxinator_store = bktree:new()
    for _, p in ipairs(projects) do
      tmuxinator_store:insert(p)
    end
  end

  local ret = {}
  local max = 15
  if arg == "" then
    max = 100
  end
  local result = tmuxinator_store:query(arg, max)
  for _, v in pairs(result) do
    if fn(v.str) then
      table.insert(ret, v.str)
    end
  end
  return ret
end --}}}

local function start_completion(arg) --{{{
  local store = running_tmuxinator_projects()
  return tm_completion(arg, function(v)
    return not store[v]
  end)
end --}}}

local function stop_completion(arg) --{{{
  local store = running_tmuxinator_projects()
  return tm_completion(arg, function(v)
    return store[v]
  end)
end --}}}

local function do_tmuxinator(command, project) --{{{
  tmuxinator_store = false
  project_store = false
  require("plenary.job")
    :new({
      command = "tmuxinator",
      args = { command, project },
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          local res = table.concat(j:stderr_result(), "\n")
          vim.notify(res, vim.lsp.log_levels.ERROR, {
            title = "Executing tmuxinator " .. command,
            timeout = 5000,
          })
        end
      end,
    })
    :start()
end --}}}

quick.command("TMStart", function(args)
  do_tmuxinator("start", args.args)
end, { nargs = "+", complete = start_completion, desc = "start a tmuxinator project" })

quick.command("TMStop", function(args)
  do_tmuxinator("stop", args.args)
end, { nargs = "+", complete = stop_completion, desc = "stop a tmuxinator project" })

quick.command("Lorem", function(args) --{{{
  local count = args.count
  if count == 0 then
    count = 1
  end
  local lorem = vim.fn.systemlist("lorem -lines " .. count)
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, cur_line - 1, cur_line - 1, false, lorem)
end, { desc = "insert lorem ipsum text", count = true }) --}}}

quick.command("UnlinkSnippets", function() --{{{
  local session = require("luasnip.session")
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
end, { desc = "Unlink all open snippets" }) --}}}

return M

-- vim: fdm=marker fdl=0
