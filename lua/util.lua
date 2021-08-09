local M = {}

-- profile prints the time it takes to run the fn function if the
-- vim.g.run_profiler is set to true.
function M.profiler(name, fn)
    local profiler = vim.g.run_profiler or false
    if profiler ~= true then
        fn()
        return
    end
    if type(name) == 'function' then
        fn = name
        name = 'an unknown operation'
    end
    local start = vim.loop.hrtime()
    fn()
    name = string.format(': for running %s', name)
    print((vim.loop.hrtime() - start)/1e6, name)
end

function M.Dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function M.cwr()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

function M.tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function M.termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, false, false)
end

-- mkdir_home creates a new folder in $HOME if not exists.
function M.mkdir_home(dir)
    local path = vim.env.HOME .. '/' .. dir
    local p = require('plenary.path'):new(path)
    if not p:exists() then
        return p:mkdir()
    end
    return true
end

-- Example: map {'n', '<Leader>w', ':write<CR>', silent=true}
-- deprecated
function M.map_key(key)
    -- get the extra options
    local opts = {noremap = true}
    for i, v in pairs(key) do
        if type(i) == 'string' then opts[i] = v end
    end

    -- basic support for buffer-scoped keybindings
    local buffer = opts.buffer
    opts.buffer = nil

    if buffer then
        vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end


local send_mark_key = M.termcodes("m'")
local send_zz_key = M.termcodes('zz')

-- jump_and_centre pushes the current location to the jumplist and calls the fn
-- callback, then centres the cursor.
function M.call_and_centre(fn)
    vim.api.nvim_feedkeys(send_mark_key, 'n', true)
    fn()
    vim.schedule(function()
        vim.api.nvim_feedkeys(send_zz_key, 'n', true)
    end)
end

-- cmd_and_centre pushes the current location to the jumplist and calls the
-- cmd, then centres the cursor. cmd should be a string.
function M.cmd_and_centre(cmd)
    vim.api.nvim_feedkeys(send_mark_key, 'n', true)
    vim.cmd(cmd)
    vim.schedule(function()
        vim.api.nvim_feedkeys(send_zz_key, 'n', true)
    end)
end

-- usage: for v in values({1, 2, 3}) do print(v) end
function M.values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end


function string.startswith(s, n)
	return s:sub(1, #n) == n
end

function string.endswith(self, str)
  return self:sub(-#str) == str
end

-- Create a highlight group.
-- @param group name of the highlight group.
-- @param opt is additional properties. Keys are: style, guifg, guibg, guisp,
-- ctermfg, ctermbg.
function M.highlight(group, opt)
    local style = opt.style and 'gui = ' .. opt.style or 'gui = NONE'
    local guifg = opt.guifg and 'guifg = ' .. opt.guifg or 'guifg = NONE'
    local guibg = opt.guibg and 'guibg = ' .. opt.guibg or 'guibg = NONE'
    local guisp = opt.guisp and 'guisp = ' .. opt.guisp or ''
    local ctermfg = opt.ctermfg and 'ctermfg = ' .. opt.ctermfg or ''
    local ctermbg = opt.ctermbg and 'ctermbg = ' .. opt.ctermbg or ''
    local str = string.format( [[highlight %s %s %s %s %s %s %s]],
    group, style, guifg, guibg, ctermfg, ctermbg, guisp
    )
    vim.cmd(str)
end

-- doesn't apply here.
function M.highlight_fast(group, opt)
    local t = {
        'highlight ',
        group,
        ' gui = NONE ',
        ' guifg = NONE ',
        ' guibg = NONE ',
    }
    if opt.style ~= nil then
        t[3] = ' gui = ' .. opt.style
    end
    if opt.guifg ~= nil then
        t[4] = ' guifg = ' .. opt.guifg
    end
    if opt.guibg ~= nil then
        t[5] = ' guibg = ' .. opt.guibg
    end
    if opt.guisp ~= nil then
        t[6] = ' guisp = ' .. opt.guisp
    end
    if opt.ctermfg ~= nil then
        t[7] = ' ctermfg = ' .. opt.ctermfg
    end
    if opt.ctermbg ~= nil then
        t[8] = ' ctermbg = ' .. opt.ctermbg
    end
    vim.cmd(table.concat(t))
end


local command = {}

-- Have to use a global to handle re-requiring this file and losing all of the
-- commands.
__CommandStore = __CommandStore or {}
command._store = __CommandStore

command._create = function(f)
  table.insert(command._store, f)
  return #command._store
end

function M._exec_command(id)
  command._store[id]()
end


-- M.command{"Name", function() print(1) end}
-- M.command{"Name", "echo 'it works!'"}
-- M.command{name="Name", fn="echo 'it works!'"}
-- M.command{"Name", "echo 'it works!'", silent=true}
-- M.command{"Name", "grep a", silent=true, post_run="cw"}
-- @param opt contain the following:
--    name     : string
--    silent   : boolean
--    run      : string or function
--    attrs    : string
--    post_run : string
function M.command(opts)
    local args = {}
    local silent = ""
    for k, v in pairs(opts) do
        if type(k) == 'number' then
            args[k] = v
        end
        if k == 'silent' then
            silent = ' silent! '
        end
    end

    local name = opts.name or args[1]
    local run = opts.run or args[2]
    local attrs = opts.attrs or ""
    local post_run = opts.post_run or ""

    local command_str
    if type(run) == 'string' then
        command_str = run
    elseif type(run) == 'function' then
        local func_id = command._create(run)
        command_str = string.format(
        [[lua require('util')._exec_command(%s)]], func_id
        )
    else
        error("Unexpected type to run:" .. tostring(run))
    end

    local str = string.format([[command! %s %s %s execute "%s"]], attrs, name, silent, command_str)
    if post_run ~= "" then
        str = str .. " | " .. post_run
    end
    vim.cmd(str)
end

local autocmd = {}
__AutocmdStore = __AutocmdStore or {}
autocmd._store = __AutocmdStore

autocmd._create = function(f)
  table.insert(autocmd._store, f)
  return #autocmd._store
end

function M._exec_autocmd(id)
  autocmd._store[id]()
end

-- M.autocmd{"Name", {
--      {"BufRead", "<buffer>", function() print(1) end},
--      {"BufRead", "*", run=function() print(1) end},
--      {targets="BufRead,BufReadPost", "*", "setlocal spell"},
-- }}
-- @param each opts contain the following:
--    group="Group"
--    events="E1,E2"    : or you can set the buffer to true
--    tergets="*.go"
--    buffer=true
--    silent=true
--    run=string or function
function M.autocmd(opts)
    local name = opts.name or opts[1]
    if name == "" then
        error("Need group name (name)")
    end

    local cmds = opts.cmds or opts[2]
    local items = {}

    for _, opt in pairs(cmds) do
        local args = {}
        local silent = ""

        for k, v in pairs(opt) do
            if type(k) == 'number' then
                args[k] = v
            end
            if k == 'silent' and v then
                silent = 'silent!'
            end
            if k == 'buffer' and v then
                args[2] = '<buffer>'
            end
        end
        local events = opt.events or args[1]
        local targets = opt.targets or args[2]
        local run = opt.run or args[3]

        local autocmd_str
        if type(run) == 'string' then
            autocmd_str = run
        elseif type(run) == 'function' then
            local func_id = autocmd._create(run)
            autocmd_str = string.format(
            [[lua require('util')._exec_autocmd(%s)]], func_id
            )
        else
            error("Unexpected type to run:" .. tostring(run))
        end
        table.insert(items, string.format([[%s %s %s execute "%s"]], events, targets, silent, autocmd_str))
    end

    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd! *')
    for _, def in pairs(items) do
        vim.cmd(table.concat(vim.tbl_flatten { "autocmd", def }, " "))
    end
    vim.cmd('augroup END')
end

return M
