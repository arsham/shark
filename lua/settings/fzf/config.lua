local util = require('util')
table.insert(vim.opt.rtp, "~/.fzf")

local function goto_def(lines)
    local file = lines[1]
    vim.api.nvim_command(("e %s"):format(file))
    if util.lsp_attached() then
        pcall(vim.lsp.buf.document_symbol)
    else
        vim.api.nvim_command(":BTags")
    end
end

local function goto_line(lines)
    local file = lines[1]
    vim.api.nvim_command(("e %s"):format(file))
    util.normal('n', ':')
end

local function search_file(lines)
    local file = lines[1]
    vim.api.nvim_command(("e +BLines %s"):format(file))
end

local function set_qf_list(files)
    local item = {
        lnum = 1,
        col = 1,
        text = "Added with fzf selection",
    }
    local lists = require('lists')
    for _, filename in pairs(files) do
        item.filename = filename
        lists.insert_list(item, false)
    end
    vim.cmd[[copen]]
end

vim.g.fzf_action = {
    ['ctrl-t'] = 'tab split',
    ['ctrl-x'] = 'split',
    ['ctrl-v'] = 'vsplit',
    ['alt-q']  = set_qf_list,
    ['@']      = goto_def,
    [':']      = goto_line,
    ['/']      = search_file,
}

vim.g.fzf_commands_expect = 'enter'
vim.g.fzf_layout = {
    window = {
        width     = 1,
        height    = 0.5,
        yoffset   = 1,
        highlight = "Comment",
        border    = 'none',
    },
}

vim.g.fzf_buffers_jump = 1          -- [Buffers] Jump to the existing window if possible
vim.g.fzf_preview_window = {'right:50%:+{2}-/2,nohidden', 'ctrl-/'}
vim.g.fzf_commits_log_options = table.concat({
    [[ --graph --color=always                                    ]],
    [[ --format="%C(yellow)%h%C(red)%d%C(reset)                  ]],
    [[ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)" ]],
}, " ")

-- fix escape in fzf popup.
require('util').augroup{"FZF_FIXES", {
    {"FileType", "fzf", run="tnoremap <buffer> <esc> <c-c>"},
    -- {"FileType", "fzf", run=function()
    --     vim.cmd("set laststatus=0 noshowmode noruler")
    --     require('util').autocmd{"BufLeave", buffer=true, run="set laststatus=2 showmode ruler"}
    -- end},
}}
