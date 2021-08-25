require('util.string')
require('util.table')
local M = {}

-- profile prints the time it takes to run the fn function if the
-- vim.g.run_profiler is set to true.
function M.profiler(name, fn)
    if vim.g.run_profiler ~= true then
        fn()
        return
    end
    if type(name) == 'function' then
        fn = name
        name = 'an unknown operation'
    end
    local start = vim.loop.hrtime()
    fn()
    local msg = ('%f: for running %s'):format((vim.loop.hrtime() - start)/1e6, name)
    vim.notify(msg, "info", {
        title = "Duration",
    })
end

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function M.cwr()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

-- Executes a normal command in normal mode.
-- @param mode string: see feedkeys() documentation.
-- @param motion string: what you mean to do in normal mode.
function M.normal(mode, motion)
    local sequence = vim.api.nvim_replace_termcodes(motion, true, false, false)
    vim.api.nvim_feedkeys(sequence, mode, true)
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

-- Pushes the current location to the jumplist and calls the fn callback, then
-- centres the cursor.
-- @param fn callable: a lua function to be run.
function M.call_and_centre(fn)
    M.normal('n', "m'")
    fn()
    vim.schedule(function()
        M.normal('n', 'zz')
    end)
end

-- Pushes the current location to the jumplist and calls the cmd, then centres
-- the cursor.
-- @param cmd string
function M.cmd_and_centre(cmd)
    M.normal('n', "m'")
    vim.cmd(cmd)
    vim.schedule(function()
        M.normal('n', 'zz')
    end)
end

-- Create a highlight group.
-- @param group name of the highlight group.
-- @param opt is additional properties. Keys are: style, guifg, guibg, guisp,
-- ctermfg, ctermbg.
function M.highlight(group, opt)
    local style   = opt.style   and 'gui = '     .. opt.style   or 'gui = NONE'
    local guifg   = opt.guifg   and 'guifg = '   .. opt.guifg   or 'guifg = NONE'
    local guibg   = opt.guibg   and 'guibg = '   .. opt.guibg   or 'guibg = NONE'
    local guisp   = opt.guisp   and 'guisp = '   .. opt.guisp   or ''
    local ctermfg = opt.ctermfg and 'ctermfg = ' .. opt.ctermfg or ''
    local ctermbg = opt.ctermbg and 'ctermbg = ' .. opt.ctermbg or ''
    local str     = ([[highlight %s %s %s %s %s %s %s]]):format(
        group, style, guifg, guibg, ctermfg, ctermbg, guisp
    )
    vim.cmd(str)
end

local storage = {}

-- Have to use a global to handle re-requiring this file and losing all of the
-- commands.
__ContextStorage = __ContextStorage or {}
storage._store = __ContextStorage

storage._create = function(f)
    table.insert(storage._store, f)
    return #storage._store
end

function M._exec_command(id, ...)
    storage._store[id](...)
end

-- Creates a command from provided specifics.
-- @param opt table: contain the following:
--    name|[1]       string: name of the command.
--    run|[2]        string or function
--    attrs optional string: command atts that land before the name.
--    docs           string: is handy when you query verbose command.
--    silent         boolean
--    post_run       string: a post action.
function M.command(opts)
    local args = {}

    for k, v in pairs(opts) do
        args[k] = v
        if k == 'silent' then
            args.silent = 'silent!'
        end
    end

    local name = args.name or args[1]
    local run = args.run or args[2]
    local attrs = args.attrs or ""
    local post_run = args.post_run or ""
    local docs =  args.docs or 'no documents'
    local silent = args.silent or ""

    local command_str
    if type(run) == 'string' then
        command_str = ('execute "%s"'):format(run)
    elseif type(run) == 'function' then
        local func_id = storage._create(run)
        command_str = ([[lua require('util')._exec_command(%s, <q-args>) -- %s]]):format(func_id, docs)
    else
        error("Unexpected type to run (".. docs .. "):" .. tostring(run))
    end

    local str = ([[command! %s %s %s %s]]):format(attrs, name, silent, command_str)
    if post_run ~= "" then
        str = str .. " | " .. post_run
    end
    vim.cmd(str)
end

-- Creates an augroup with a set of autocmds.
-- @param table: contain the following:
--    name|[1] string: name of the group. Should be unique.
--    cmds|[2] table: an array of autocmds. See M.autocmd.
function M.augroup(opts)
    local name = opts.name or opts[1]
    if name == "" then
        error("Need group name (name)")
    end

    local cmds = opts.cmds or opts[2]

    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd! *')
    for _, def in pairs(cmds) do
        M.autocmd(def)
    end
    vim.cmd('augroup END')
end

-- Creates a single autocmd. You most likely want to use it in a context of an
-- augroup.
-- @param table: contain the following:
--    events|[1]    string: "E1,E2"; or you can set the buffer to true
--    tergets|[2]   string: "*.go"
--    run|[3]       string or function
--    docs          string: is handy when you query verbose command.
--    buffer        boolean
--    silent        boolean
function M.autocmd(opts)
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

    local events = args.events or args[1]
    local targets = args.targets or args[2] or ""
    local run = args.run or args[3]
    local buffer = args.buffer or ""
    local docs = args.docs or "no documents"
    local silent = args.silent or ""

    local autocmd_str
    if type(run) == 'string' then
        autocmd_str = ('execute "%s"'):format(run)
    elseif type(run) == 'function' then
        local func_id = storage._create(run)
        autocmd_str = ([[lua require('util')._exec_command(%s) -- %s]]):format(func_id, docs)
    else
        error("Unexpected type to run (" .. docs .. "): " .. tostring(run))
    end

    local def = ([[%s %s %s %s %s]]):format(events, targets, buffer, silent, autocmd_str)
    vim.cmd(table.concat(vim.tbl_flatten { "autocmd", def }, " "))
end

M.job_str = function(str)
    local job = require('plenary.job')
    local cmd = vim.split(str, " ")
    job:new({
        command = cmd[1],
        args = table.slice(cmd, 2, #cmd),
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

-- Takes the user input in a popup.
-- @param opts table: to override the vim.notify config table. Try prompt or
-- on_submit.
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

-- Returns true if there is an active lsp server attached to current buffer.
function M.lsp_attached()
    local clients = vim.lsp.get_active_clients()
    if next(clients) ~= nil then
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return true
            end
        end
    end
    return false
end

return M
