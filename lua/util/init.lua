if not pcall(require, 'nvim') then return end
local nvim = require('nvim')
require('util.tables')
require('util.strings')

local M = {
  profiler_enabled = false,
  profiler_path = vim.env.HOME..'/tmp',
}

---Prints the time it takes to run the fn function if the vim.g.run_profiler is
---set to true.
---@param name string|function if a function, you can ignore the fn
---@param fn function
function M.profiler(name, fn)
  if type(name) == 'function' then
    fn = name
    name = 'unknown'
  end
  if not M.profiler_enabled then
    fn()
    return
  end
  local filename = M.profiler_path .. '/nvim_profiler_' .. name .. '.log'
  local msg = 'Profile results are at ' .. filename

  require'plenary.profile'.start(filename, {flame = true})
  fn()
  require'plenary.profile'.stop()
  vim.notify(msg, "info", {
    title = name,
  })
end

---Prints the time it takes to run the fn function.
---@param fn function
function M.timeit(fn)
  local start = vim.loop.hrtime()
  fn()
  local msg = ('%fs'):format((vim.loop.hrtime() - start)/1e6)
  print(msg)
end

---Dumps any values
---@vararg any
-- selene: allow(global_usage)
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

function M.cwr()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

---Executes a normal command in normal mode.
---@param mode string @see vim.api.nvim_feedkeys().
---@param motion string what you mean to do in normal mode.
function M.normal(mode, motion)
  local sequence = vim.api.nvim_replace_termcodes(motion, true, false, false)
  vim.api.nvim_feedkeys(sequence, mode, true)
end

---mkdir_home creates a new folder in $HOME if not exists.
---@param dir string
---@return boolean #success result
function M.mkdir_home(dir)
  local path = vim.env.HOME .. '/' .. dir
  local p = require('plenary.path'):new(path)
  if not p:exists() then
    return p:mkdir()
  end
  return true
end

---Pushes the current location to the jumplist and calls the fn callback, then
---centres the cursor.
---@param fn function
function M.call_and_centre(fn)
  M.normal('n', "m'")
  fn()
  vim.schedule(function()
    M.normal('n', 'zz')
  end)
end

---Pushes the current location to the jumplist and calls the cmd, then centres
---the cursor.
---@param cmd string
function M.cmd_and_centre(cmd)
  M.normal('n', "m'")
  vim.cmd(cmd)
  vim.schedule(function()
    M.normal('n', 'zz')
  end)
end

---@class HighlightOpt
---@field style string
---@field guifg string
---@field guibg string
---@field guisp string
---@field ctermfg string
---@field ctermbg string

---Create a highlight group.
---@param group string name of the highlight group.
---@param opt HighlightOpt additional properties.
function M.highlight(group, opt)
  vim.validate {
    opt = {opt, 't'},
    ['opt.style']   = {opt.style,   's', true},
    ['opt.guifg']   = {opt.guifg,   's', true},
    ['opt.guibg']   = {opt.guibg,   's', true},
    ['opt.guisp']   = {opt.guisp,   's', true},
    ['opt.ctermfg'] = {opt.ctermfg, 's', true},
    ['opt.ctermbg'] = {opt.ctermbg, 's', true},
  }

  local style   = opt.style   and 'gui = '     .. opt.style   or 'gui = NONE'
  local guifg   = opt.guifg   and 'guifg = '   .. opt.guifg   or 'guifg = NONE'
  local guibg   = opt.guibg   and 'guibg = '   .. opt.guibg   or 'guibg = NONE'
  local guisp   = opt.guisp   and 'guisp = '   .. opt.guisp   or ''
  local ctermfg = opt.ctermfg and 'ctermfg = ' .. opt.ctermfg or ''
  local ctermbg = opt.ctermbg and 'ctermbg = ' .. opt.ctermbg or ''

  local str     = table.concat({
    group, style, guifg, guibg, ctermfg, ctermbg, guisp
  }, ' ')
  nvim.ex.highlight(str)
end

local storage = {}

---Have to use a global to handle re-requiring this file and losing all of the
---commands.
__ContextStorage = __ContextStorage or {}
storage._store = __ContextStorage

storage._create = function(f)
  table.insert(storage._store, f)
  return #storage._store
end

function M._exec_command(id, ...)
  storage._store[id](...)
end

---Creates a command from provided specifics.
---@param name string
---@param command string|function
---@param opts dict
function M.command(name, command, opts)
  opts = opts or {}
  opts.force = true
  vim.api.nvim_add_user_command(name, command, opts)
end

---Creates a command from provided specifics on current buffer.
---@param name string
---@param command string|function
---@param opts dict
function M.buffer_command(name, command, opts)
  opts = opts or {}
  opts.force = true
  vim.api.nvim_buf_add_user_command(0, name, command, opts)
end

---@class AugroupOpt
---@field name string also the first field. Name of the group. Should be unique.
---@field cmds? AutocmdOpt[] if empty then it only creates the augroup. @see M.autocmd.

---Creates an augroup with a set of autocmds.
---@param opts AugroupOpt
function M.augroup(opts)
  local name = opts.name or opts[1]
  vim.validate{
    name = {name, function(n) return n ~= '' end, 'non empty group name'},
    opts = {opts, 't', true},
  }

  local cmds = opts.cmds or opts[2]
  if not cmds then
    cmds = {}
  end

  nvim.ex.augroup(name)
  nvim.ex.autocmd_('*')
  for _, def in pairs(cmds) do
    M.autocmd(def)
  end
  nvim.ex.augroup('END')
end

---@class AutocmdOpt
---@field group?   string the group to attach to.
---@field events   string "E1,E2"; or you can set the buffer to true
---@field tergets? string "*.go"
---@field run      string or function
---@field docs?    string is handy when you query verbose command.
---@field buffer?  boolean
---@field silent?  boolean
---@field once?    boolean adds ++once

---Creates a single autocmd. You most likely want to use it in a context of an
---augroup.
---@param opts AutocmdOpt[]
function M.autocmd(opts)
  vim.validate{
    opts = {opts, 't'},
  }
  local args = {}

  for k, v in pairs(opts) do
    args[k] = v
    if k == 'silent' and v then
      args.silent = 'silent!'
    end
    if k == 'buffer' and v then
      args.buffer = '<buffer>'
    end
  end

  local events  = args.events or args[1]
  local targets = args.targets or args[2] or ""
  local run     = args.run or args[3]
  local buffer  = args.buffer or ""
  local docs    = args.docs or "no documents"
  local silent  = args.silent or ""
  local once    = args.once and '++once' or ""
  local group   = args.group or ""

  local autocmd_str
  if type(run) == 'string' then
    autocmd_str = ('execute "%s"'):format(run)
  elseif type(run) == 'function' then
    local func_id = storage._create(run)
    autocmd_str = ([[lua require('util')._exec_command(%s) -- %s]]):format(func_id, docs)
  else
    error("Unexpected type to run (" .. docs .. "): " .. tostring(run))
  end

  local def = table.concat({group, events, targets, buffer, silent, once, autocmd_str}, ' ')
  nvim.ex.autocmd(def)
end

M.job_str = function(str)
  local job = require('plenary.job')
  local cmd = vim.split(str, ' ')
  job:new({
    command = cmd[1],
    args = _t(cmd):slice(2, #cmd),
    on_exit = function(j, exit_code)
      local res = table.concat(j:result(), "\n")
      if #res == 0 then
        res = "No output"
      end

      local type = vim.lsp.log_levels.INFO
      if exit_code ~=0 then
        type = vim.lsp.log_levels.ERROR
        res = table.concat(j:stderr_result(), "\n")
      end

      vim.notify(res, type, {
        title = str,
        timeout = 3000,
      })
    end,
  }):start()
end

local popup_options = {
  border = {
    style = 'rounded',
    highlight = 'FloatBorder',
  },
  position = '50%',
  size = {
    width = '80%',
    height = '100%',
  },
}

---Takes the user input in a popup.
---@param opts table to override the vim.notify config table. Try prompt or
---on_submit.
function M.user_input(opts)
  local conf = {
    prompt = '> ',
    on_submit = function(value)
      vim.notify(value, vim.lsp.log_levels.INFO, {
        title = 'User Input',
        timeout = 2000,
      })
    end,
  }

  conf = vim.tbl_deep_extend("force", conf, opts)
  local input = require('nui.input')(popup_options, {
    prompt = conf.prompt,
    zindex = 10,
    on_submit = conf.on_submit,
  })

  input:mount()
  input:map('i', '<esc>', input.input_props.on_close, { noremap = true })
  local event = require('nui.utils.autocmd').event

  input:on(event.BufHidden, function()
    vim.schedule(function()
      input:unmount()
    end)
  end)
end

M.colours = {
  black   = 30,
  red     = 31,
  green   = 32,
  yellow  = 33,
  blue    = 34,
  magenta = 35,
  cyan    = 36,
}

---Returns a string that prints a colorized version of the given table suitable
---for terminal output.
---@param colour any item from the colours table.
---@param text string text to colorize.
---@return string
function M.ansi_color(colour, text)
  -- selene: allow(bad_string_escape)
  return ("\x1b[%s;1;m%s\x1b[m"):format(colour, text)
end


---Returns a pair of canonical name and the module name.
---@param filename string
---@return string
---@return string
---@return boolean when the filename matches a correct module.
local function try_filename(filename)
  local patterns = {
    [[/nvim/lua/(.+.lua)$]],
    [[/nvim/([%a\/]+.+.lua)$]],
    [[nvim/lua/(.+.lua)$]],
    [[lua/(.+.lua)$]],
    [[(.+.lua)$]],
  }
  for _, pattern in ipairs(patterns) do
    local name = filename:match(pattern)
    if name then
      local mod_name = name:match('(.+).lua$')
      mod_name, _= mod_name:gsub('/', '.')
      return name, mod_name, true
    end
  end
  return '', '', false
end

---@class file_module
---@field module string the module name
---@field filepath string the filepath
---@field name string the name of the file

---Returns a pair of canonical name and the module name.
---@param filename string
---@return file_module
---@return boolean true if it can load the module and the module is in the path.
function M.file_module(filename)
  local mod = {}
  local name, mod_name, ok = try_filename(filename)
  local loaded = pcall(require, mod_name)

  ok = ok and loaded
  if ok then
    mod.module = mod_name
    mod.filepath = filename
    mod.name = name
  end
  return mod, ok
end

---@class mapping_options
---@field lhs? string or first element key to trigger the mapping.
---@field rhs? string or second element. Should be empty if callback is given.
---@field callback? function
---@field buffer? boolean
---@field silent? boolean
---@field noremap? boolean
---@field expr? string

---Creates mappings.
---@param mode string
---@param conf mapping_options
function M.map(mode, conf)
  local opts, map_opts = {}, {}
  for k, v in pairs(conf) do
    if type(k) == "number" then
      opts[k] = v
    else
      map_opts[k] = v
    end
  end

  local lhs = opts.lhs or conf[1]
  local rhs = opts.rhs or conf[2]

  if type(rhs) == 'function' then
    map_opts.callback = rhs
    rhs = ''
  end

  vim.validate {
    mode = {mode, {'s', 't'}},
    lhs  = {lhs,  's'},
    rhs  = {rhs,  {'s', 'f'}},
    opts = {opts, 't',  true}
  }

  if conf.buffer then
    map_opts.buffer = nil
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, map_opts)
    return
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, map_opts)
end

---Create a normal mode mapping.
---@param conf mapping_options
function M.nmap(conf) M.map('n', conf) end
---Create a mapping for insert mode.
---@param conf mapping_options
function M.imap(conf) M.map('i', conf) end
---Create a mapping for visual mode.
---@param conf mapping_options
function M.vmap(conf) M.map('v', conf) end
---Create a mapping for visual mode.
---@param conf mapping_options
function M.xmap(conf) M.map('x', conf) end
---Create a mapping for operator-pending mode.
---@param conf mapping_options
function M.omap(conf) M.map('o', conf) end
---Create a mapping for command-line mode.
---@param conf mapping_options
function M.cmap(conf) M.map('c', conf) end
---Create a mapping for terminal mode.
---@param conf mapping_options
function M.tmap(conf) M.map('t', conf) end

---Not to be consumed by users.
---@param mode string
---@param conf mapping_options
function M._noremap(mode, conf)
  conf.noremap = true
  M.map(mode, conf)
end

function M.noremap(conf) M._noremap('', conf) end

---Create a normal mode mapping.
---@param conf mapping_options
function M.nnoremap(conf) M._noremap('n', conf) end
---Create a mapping for insert mode.
---@param conf mapping_options
function M.inoremap(conf) M._noremap('i', conf) end
---Create a mapping for visual mode.
---@param conf mapping_options
function M.vnoremap(conf) M._noremap('v', conf) end
---Create a mapping for visual mode.
---@param conf mapping_options
function M.xnoremap(conf) M._noremap('x', conf) end
---Create a mapping for operator-pending mode.
---@param conf mapping_options
function M.onoremap(conf) M._noremap('o', conf) end
---Create a mapping for command-line mode.
---@param conf mapping_options
function M.cnoremap(conf) M._noremap('c', conf) end
---Create a mapping for terminal mode.
---@param conf mapping_options
function M.tnoremap(conf) M._noremap('t', conf) end

return M
