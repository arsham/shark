local M = {}

M.force_inactive = {
    filetypes = {
        'NvimTree',
        'dbui',
        'packer',
        'startify',
        'fugitive',
        'fugitiveblame'
    },
    buftypes  = {
        'terminal'
    },
    bufnames  = {}
}

M.colors = {
    white         = "#b5bcc9",
    grey_fg       = "#737D87",
    short_bg      = "#34393D",
    red           = "#ef8891",
    red_dark      = "#B31F1F",
    green         = "#9ce5c0",
    green_pale    = "#839C8F",
    nord_blue     = "#9aa8cf",
    yellow        = "#fbdf90",
    yellow_pale   = "#B39E67",
    purple        = "#A300ED",
    statusline_bg = "#181f26",
    light_bg      = "#222930",
    light_bg2     = "#1d242b",
    mid_bg        = "#2B3033",
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

M.vi_mode_colors = {
    NORMAL        = 'green',
    OP            = 'green',
    INSERT        = 'red',
    VISUAL        = 'skyblue',
    LINES         = 'skyblue',
    BLOCK         = 'skyblue',
    REPLACE       = 'violet',
    ['V-REPLACE'] = 'violet',
    ENTER         = 'cyan',
    MORE          = 'cyan',
    SELECT        = 'orange',
    COMMAND       = 'green',
    SHELL         = 'green',
    TERM          = 'green',
    NONE          = 'yellow'
}

M.separators = {
    vertical_bar       = '┃',
    vertical_bar_thin  = '│',
    left               = '',
    right              = '',
    block              = '█',
    left_filled        = '',
    right_filled       = '',
    slant_left         = '',
    slant_left_thin    = '',
    slant_right        = '',
    slant_right_thin   = '',
    slant_left_2       = '',
    slant_left_2_thin  = '',
    slant_right_2      = '',
    slant_right_2_thin = '',
    left_rounded       = '',
    left_rounded_thin  = '',
    right_rounded      = '',
    right_rounded_thin = '',
    circle             = '●',
    github_icon        = " ﯙ ",
}

function M.vim_mode()
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

function M.ale_diagnostics()
    local error = 0
    local warning = 0
    local info = 0

    local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
    if not ok then
        return ""
    end
    error = data.error + data.style_error
    warning = data.warning + data.style_warning
    info = data.info

    local ret = {}

    if error + warning + info == 0 then
        return ""
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
        table.insert(ret, '')
        table.insert(ret, info)
    end

    return table.concat(ret, ' ') .. ' '
end

-- Return parent path for specified entry (either file or directory), nil if
-- there is none
-- Adapted from from galaxyline.
local function parent_pathname(path)
    local i = path:find("[\\/:][^\\/:]*$")
    if not i then return end
    return path:sub(1, i-1)
end

-- Adapted from from galaxyline.
local function get_git_dir(path)

    -- Checks if provided directory contains git directory
    local function has_git_dir(dir)
        local git_dir = dir..'/.git'
        if vim.fn.isdirectory(git_dir) == 1 then return git_dir end
    end

    -- Get git directory from git file if present
    local function has_git_file(dir)
        local gitfile = io.open(dir..'/.git')
        if gitfile ~= nil then
            local git_dir = gitfile:read():match('gitdir: (.*)')
            gitfile:close()

            return git_dir
        end
    end

    -- Check if git directory is absolute path or a relative
    local function is_path_absolute(dir)
        local patterns = {
            '^/',        -- unix
            '^%a:[/\\]', -- windows
        }
        for _, pattern in ipairs(patterns) do
            if string.find(dir, pattern) then
                return true
            end
        end
        return false
    end

    -- If path nil or '.' get the absolute path to current directory
    if not path or path == '.' then
        path = vim.fn.getcwd()
    end

    local git_dir
    -- Check in each path for a git directory, continues until found or reached
    -- root directory
    while path do
        -- Try to get the git directory checking if it exists or from a git file
        git_dir = has_git_dir(path) or has_git_file(path)
        if git_dir ~= nil then
            break
        end
        -- Move to the parent directory, nil if there is none
        path = parent_pathname(path)
    end

    if not git_dir then return end

    if is_path_absolute(git_dir) then
        return git_dir
    end
    return  path .. '/' .. git_dir
end

function M.git_root()
    local git_dir = get_git_dir()
    if not git_dir then
        return ""
    end

    local root = git_dir:gsub('/.git/?', '')
    -- sub_root is a path to a worktree if exists.
    local sub_root = git_dir:match('/([^/]+)/.git/worktrees/.+$')
    local repo = ''
    if sub_root then
        repo = ' ['..sub_root..']'
    end
    return root:match '^.+/(.+)$' .. repo
end

function M.dir_name(_, opts)
    if opts.short then
        return vim.fn.expand('%:h'):match('[^/\\]+$') or ""
    end
    return vim.fn.expand("%:h") or ""
end

local function filename(short)
    if #vim.fn.expand '%:p' == 0 then
        return '-'
    end
    if short then
        return vim.fn.expand '%:t'
    end
    return vim.fn.expand '%:~'
end

local function file_readonly()
    if vim.bo.filetype == 'help' then
        return ''
    end
    local icon = ''
    if vim.bo.readonly == true then
        return " " .. icon .. " "
    end
    return ''
end

function M.filename(_, opts)
    local short = opts.short or false
    local file = filename(short)
    if vim.fn.empty(file) == 1 then
        return ''
    end
    if string.len(file_readonly()) ~= 0 then
        return file .. file_readonly()
    end
    local icon = ''
    if vim.bo.modifiable and vim.bo.modified then
        return file .. ' ' .. icon .. '  '
    end
    return file .. ' '
end

function M.search_results()
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 50000 then
        return ""
    end
    local search_term = vim.fn.getreg('/')
    if search_term == "" then return "" end
    if search_term:find("@") then return "" end

    local search_count = vim.fn.searchcount({recompute = 1, maxcount = -1})
    local active = false
    if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
        active = true
    end

    if active then
        return '/' .. search_term .. '[' .. search_count.current .. '/' .. search_count.total .. ']'
    end
    return ""
end

function M.locallist_count()
    local count = #vim.fn.getloclist(0)
    return ("  %d "):format(count)
end

function M.quickfix_count()
    local count = #vim.fn.getqflist()
    return ("  %d "):format(count)
end

return M
