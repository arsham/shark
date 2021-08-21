local command = require('util').command
require('settings.fzf.util')

command{"Notes",    "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", attrs="-bang"}
command{"Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", attrs="-bang"}

-- command{"Todo",             "grep todo|fixme **/*", post_run="cw", silent=true}
command{"Todo", function()
    local t = {
        [[ call fzf#vim#grep(                          ]],
        [[     'rg --column --line-number --no-heading ]],
        [[     --color=always --smart-case --hidden    ]],
        [[     -g "!.git/" -- "fixme|todo" ', 1,       ]],
        [[     fzf#vim#with_preview())                 ]],
    }
    vim.cmd(table.concat(t, " "))
end}

command{"Reload", function()
    local loc = vim.env['MYVIMRC']
    local base_dir = require('plenary.path'):new(loc):parents()[1]
    local t = {
        [[ call fzf#run(fzf#wrap({                                             ]],
        string.format([[     'source': 'fd . -e lua %s',            ]], base_dir),
        [[      'sink*': { lines -> v:lua.reload_config_files(lines) },        ]],
        [[      'options': '--multi --reverse --bind ctrl-a:select-all+accept' ]],
        [[ }))                                                                 ]],
    }
    vim.cmd(table.concat(t, " "))
end}

command{"Config", function()
    local t = {
        [[ call fzf#run(fzf#wrap({                                             ]],
        [[      'source': 'fd . ~/.config/nvim',                               ]],
        [[      'options': '--multi --reverse --bind ctrl-a:select-all+accept' ]],
        [[      }))                                                            ]],
    }
    vim.cmd(table.concat(t, " "))
end}

-- Delete buffers interactivly with fzf.
command{"BDelete", function()
    local t = {
        [[ call fzf#run(fzf#wrap({                                         ]],
        [[      'source': v:lua.buf_list(),                                ]],
        [[      'sink*': { lines -> v:lua.buf_delete(lines) },             ]],
        [[      'options': '--prompt "Delete Buffers > " --multi --reverse ]],
        [[                  --bind ctrl-a:select-all+accept'               ]],
        [[      }))                                                        ]],
    }
    vim.cmd(table.concat(t, " "))
end}
command{"BufDelete", "BDelete"}

-- Delete marks interactivly with fzf.
command{"MarksDelete", function()
    local t = {
        [[ call fzf#run(fzf#wrap({                             ]],
        [[      'source': v:lua.mark_list(),                   ]],
        [[      'sink*': { lines -> v:lua.mark_delete(lines) },]],
        [[      'options': '--multi --reverse                  ]],
        [[           --bind ctrl-a:select-all+accept           ]],
        [[           --header-lines=1 --prompt="Delete Mark> "']],
        [[ }), fzf#vim#with_preview())                         ]],
    }
    vim.cmd(table.concat(t, " "))
end}

local ggrep_table = {
    [[ command! -bang -nargs=* GGrep                                   ]],
    [[     call fzf#vim#grep(                                          ]],
    [[          'git grep --line-number -- '.shellescape(<q-args>), 0, ]],
    [[          fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)]],
}
vim.cmd(table.concat(ggrep_table, " "))

-- Delete args interactivly with fzf.
command{"ArgsDelete", function()
    local t = {
        [[ call fzf#run(fzf#wrap({                                             ]],
        [[      'source': argv(),                                              ]],
        [[      'sink*': { lines -> v:lua.args_delete(lines) },                ]],
        [[      'options': '--multi --reverse --bind ctrl-a:select-all+accept' ]],
        [[      }))                                                            ]],
    }
    vim.cmd(table.concat(t, " "))
end}
command{"ArgDelete", "ArgsDelete"}

command{"ArgAdd", function()
    local t = {
        [[ call fzf#run(fzf#wrap({                                             ]],
        [[      'source': v:lua.files_not_in_args(),                           ]],
        [[      'sink*': { lines -> v:lua.args_add(lines) },                   ]],
        [[      'options': '--multi --reverse --bind ctrl-a:select-all+accept' ]],
        [[      }))                                                            ]],
    }
    vim.cmd(table.concat(t, " "))
end}

command{"BLinesPrev", attrs="-bang -nargs=*", function()
    local t = {
        [[ call fzf#vim#grep(                                                    ]],
        [[     'rg --with-filename --column --line-number --no-heading           ]],
        [[           --color=never --smart-case . '.fnameescape(expand('%')), 1, ]],
        [[     fzf#vim#with_preview({'options': '--layout reverse --with-nth=4.. ]],
        [[     --delimiter=":"'}, 'right:60%:+{2}-/2', 'ctrl-/'))                ]],
    }
    vim.cmd(table.concat(t, " "))
end}

-- Opens the fzf UI with ripgrep search.
local arsham_rg_cmd = {
    [[ command! -bang -nargs=* ArshamRg                   ]],
    [[ call fzf#vim#grep(                                 ]],
    [[     'rg --column --line-number --no-heading        ]],
    [[         --color=always --smart-case --hidden       ]],
    [[         -g "!.git/" -- '.shellescape(<q-args>), 1, ]],
    [[     fzf#vim#with_preview(), <bang>0)               ]],
}
vim.cmd(table.concat(arsham_rg_cmd, " "))
