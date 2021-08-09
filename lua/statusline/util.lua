local condition = require('galaxyline.condition')

local M = {}

M.colors = {
    white = "#b5bcc9",
    grey_fg = "#51585f",
    red = "#ef8891",
    red_dark = "#B31F1F",
    green = "#9ce5c0",
    nord_blue = "#9aa8cf",
    yellow = "#fbdf90",
    purple = "#A300ED",
    statusline_bg = "#181f26",
    light_bg = "#222930",
    light_bg2 = "#1d242b",
    mid_bg = "#26292C",
}

M.mode_mappings = {
    ['n']   = {'Normal',       '-'},
    ['no']  = {'Op·Pending',   'P'},
    ['nov'] = {'Op·Pending',   'v'},
    ['noV'] = {'Op·Pending',   'V'},
    ['niI'] = {'(Normal)',     'I'},
    ['niR'] = {'(Normal)',     'R'},
    ['niV'] = {'(Normal)',     'V'},
    ['v']   = {'Visual',       'C'},
    ['V']   = {'V·Line',       'L'},
    ['']  = {'V·Block',      'B'},
    ['s']   = {'Select',       '-'},
    ['S']   = {'S·Line',       'L'},
    ['']  = {'S·Block',      'B'},
    ['i']   = {'Insert',       '-'},
    ['ic']  = {'Ins·Compl',    'C'},
    ['ix']  = {'Ins·Compl',    'X'},
    ['R']   = {'Replace',      '-'},
    ['Rv']  = {'Replace',      'V'},
    ['Rx']  = {'Replace',      'X'},
    ['c']   = {'Command',      '-'},
    ['cv']  = {'Vim·Ex',       'Q'},
    ['ce']  = {'Ex',           '-'},
    ['r']   = {'Prompt',       '-'},
    ['rm']  = {'More',         '-'},
    ['r?']  = {'Confirm',      '-'},
    ['!']   = {'Shell',        '-'},
    ['t']   = {'Terminal',     '-'},
    ['']    = {'Empty',        '-'},
}

function M.mode()
    local mode = M.mode_mappings[vim.fn.mode()]
    local value = ""

    if vim.g.libmodalActiveModeName then
        mode = { vim.g.libmodalActiveModeName, "U"}
    end

    if mode ~= nil then
        value = mode[1]
        if mode[2] ~= '-' then
            value = value .. ' [' .. mode[2] .. ']'
        end
    end
    return value
end


function M.buffer_type()
    if not condition.check_git_workspace() or vim.fn.winwidth(0) < 100 then
        return ""
    end
    local buffer_type = vim.bo.filetype:upper()
    if buffer_type == "" then
        return ""
    end
    return " " .. buffer_type .. " "
end

function M.ale_lsp()
    local icon = '  '
    local clients = vim.lsp.get_active_clients()
    if next(clients) ~= nil then
        return icon
    end
    local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
    if not ok then
        return nil
    end
    local total = data.error + data.style_error + data.warning + data.style_warning + data.info
    if total > 0 then
        return icon
    end
    return nil
end

function M.ale_diagnostics()
    local error = 0
    local warning = 0
    local info = 0

    local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
    if not ok then
        return nil
    end
    error = data.error + data.style_error
    warning = data.warning + data.style_warning
    info = data.info

    local ret = {}

    if error + warning + info == 0 then
        return nil
    end

    if error > 0 then
        table.insert(ret, '')
        table.insert(ret, error)
    end
    if warning > 0 then
        table.insert(ret, '')
        table.insert(ret, warning)
    end
    if info > 0 then
        table.insert(ret, '')
        table.insert(ret, info)
    end

    return table.concat(ret, ' ') .. ' '
end

function M.lsp_provider()
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return ""
    end
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name .. " "
        end
    end
    return ""
end

function M.git_root()
    if condition.hide_in_width() == false then
        return nil
    end
    local git_dir = require('galaxyline.provider_vcs').get_git_dir()
    if not git_dir then
        return nil
    end

    local add = "  "
    local cur_len = vim.fn.winwidth(0)
    if cur_len < 120 then
        add = " "
    end

    local root = git_dir:gsub('/.git/?$', '')
    return  "  ﯙ " .. root:match '^.+/(.+)$' .. add
end

function M.get_git_branch()
    local cur_len = vim.fn.winwidth(0)
    if cur_len < 30 then
        return nil
    end
    local branch = require('galaxyline.provider_vcs').get_git_branch()
    local cut = 20
    if #branch < cut then
        return branch
    end

    cut = cur_len - cut - 60
    if cut < 10 then
        return nil
    end
    if cut > 30 then
        cut = 30
    end

    branch = string.sub(branch, 0, cut) .. '..'
    return branch
end

local function file_readonly(readonly_icon)
    if vim.bo.filetype == 'help' then
        return ''
    end
    local icon = readonly_icon or ''
    if vim.bo.readonly == true then
        return " " .. icon .. " "
    end
    return ''
end

local function filename()
    if #vim.fn.expand '%:p' == 0 then
        return '-'
    end
    if vim.fn.winwidth(0) > 120 then
        return vim.fn.expand '%:~'
    end
    return vim.fn.expand '%:t'
end

function M.get_current_file_name(modified_icon, readonly_icon)
    local file = filename()
    if vim.fn.empty(file) == 1 then
        return ''
    end
    if string.len(file_readonly(readonly_icon)) ~= 0 then
        return file .. file_readonly(readonly_icon)
    end
    local icon = modified_icon or ''
    if vim.bo.modifiable and vim.bo.modified then
        return file .. ' ' .. icon .. '  '
    end
    return file .. ' '
end

function M.line_location()
    local current_line = vim.fn.line(".")
    local total_line = vim.fn.line("$")

    if current_line == 1 then
        return "  Top "
    end
    if current_line == vim.fn.line("$") then
        return "  Bot "
    end
    local result, _ = math.modf((current_line / total_line) * 100)
    return "  " .. result .. "% "
end

function M.parent_dir_name()
    return vim.fn.expand("%:h")
end

return M
