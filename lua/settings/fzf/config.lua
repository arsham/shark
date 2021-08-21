table.insert(vim.opt.rtp, "~/.fzf")
-- ctrl+p -> @, : and / to go to symbols, line and or search in lines.
local command = {
    {
        [[ function! GotoDef(lines) abort                         ]],
        [[     silent! exe 'e +BTags '.a:lines[0]                 ]],
        [[     call timer_start(10, {-> execute('startinsert') }) ]],
        [[ endfunction                                            ]],
    }, {
        [[ function! GotoLine(lines) abort                        ]],
        [[     silent! exe 'e '.a:lines[0]                        ]],
        [[     call timer_start(10, {-> feedkeys(':') })          ]],
        [[ endfunction                                            ]],
    }, {
        [[ function! SearchFile(lines) abort                      ]],
        [[     silent! exe 'e +Lines '.a:lines[0]                 ]],
        [[     call timer_start(10, {-> execute('startinsert') }) ]],
        [[ endfunction                                            ]],
    }, {
        [[ function! SetQFList(lines)                                     ]],
        [[     call setqflist(map(copy(a:lines), '{ "filename": v:val }'))]],
        [[     copen                                                      ]],
        [[ endfunction                                                    ]],
    }
}

for _, str in pairs(command) do
    vim.cmd(table.concat(str, "\n"))
end

local str = {
    [[ let g:fzf_action = {                 ]],
    [[     'ctrl-t': 'tab split',           ]],
    [[     'ctrl-x': 'split',               ]],
    [[     'ctrl-v': 'vsplit',              ]],
    [[     'alt-q': function('SetQFList'),  ]],
    [[     '@': function('GotoDef'),        ]],
    [[     ':': function('GotoLine'),       ]],
    [[     '/': function('SearchFile')      ]],
    [[  }                                   ]],
}
vim.cmd(table.concat(str, " "))

vim.g.fzf_commands_expect = 'enter'
vim.g.fzf_layout = { window = { width = 0.95, height = 0.95 } }
vim.g.fzf_buffers_jump = 1          -- [Buffers] Jump to the existing window if possible
vim.g.fzf_preview_window = {'right:50%:+{2}-/2',  'ctrl-/'}
vim.g.fzf_commits_log_options = table.concat({
    [[--graph --color=always                                       ]],
    [[ --format="%C(yellow)%h%C(red)%d%C(reset)                    ]],
    [[ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"   ]],
}, " ")

-- fix escape in fzf popup.
require('util').augroup{"FZF_FIXES", {
    {"FileType", "fzf", run="tnoremap <buffer> <esc> <c-c>"},
}}
