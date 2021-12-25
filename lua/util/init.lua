local nvim = require('nvim')
require('util.string')
require('util.table')

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

---@class CommandOpts
---@field name string also unnamed first element
---@field run string|function also unnamed second element
---@field attrs? string command atts that land before the name.
---@field docs string handy when you query verbose command.
---@field silent boolean
---@field post_run string: post action.

---Creates a command from provided specifics.
---@param opts CommandOpts
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

    local str = table.concat({attrs, name, silent, command_str}, ' ')
    if post_run ~= "" then
        str = str .. " | " .. post_run
    end
    nvim.ex.command_(str)
end

---@class AugroupOpt
---@field name string also the first field. Name of the group. Should be unique.
---@field cmds AutocmdOpt[] @see M.autocmd.

---Creates an augroup with a set of autocmds.
---@param opts AugroupOpt
function M.augroup(opts)
    local name = opts.name or opts[1]
    if name == "" then
        error("Need group name (name)")
    end

    local cmds = opts.cmds or opts[2]

    nvim.ex.augroup(name)
    nvim.ex.autocmd_('*')
    for _, def in pairs(cmds) do
        M.autocmd(def)
    end
    nvim.ex.augroup('END')
end

---@class AutocmdOpt
---@field events  string "E1,E2"; or you can set the buffer to true
---@field tergets string "*.go"
---@field run     string or function
---@field docs    string is handy when you query verbose command.
---@field buffer  boolean
---@field silent  boolean
---@field once    boolean adds ++once

---Creates a single autocmd. You most likely want to use it in a context of an
---augroup.
---@param opts AutocmdOpt[]
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
    local once = args.once and '++once' or ""

    local autocmd_str
    if type(run) == 'string' then
        autocmd_str = ('execute "%s"'):format(run)
    elseif type(run) == 'function' then
        local func_id = storage._create(run)
        autocmd_str = ([[lua require('util')._exec_command(%s) -- %s]]):format(func_id, docs)
    else
        error("Unexpected type to run (" .. docs .. "): " .. tostring(run))
    end

    local def = table.concat({events, targets, buffer, silent, once, autocmd_str}, ' ')
    nvim.ex.autocmd(def)
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

---Returns true if there is an active lsp server attached to current buffer.
---@return boolean
---@deprecated
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
    return ("\x1b[%s;1;m%s\x1b[m"):format(colour, text)
end

return M
