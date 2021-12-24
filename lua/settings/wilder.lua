vim.opt.wildcharm = vim.fn.char2nr('	')  -- tab
vim.fn['wilder#enable_cmdline_enter']()
vim.fn['wilder#set_option']('modes', {':'})

vim.keymap.cnoremap{'<TAB>',   'wilder#in_context() ? wilder#next()     : "\\<Tab>"',   expr=true}
vim.keymap.cnoremap{'<S-TAB>', 'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', expr=true}
vim.keymap.cnoremap{'<C-j>',   'wilder#in_context() ? wilder#next()     : "\\<Tab>"',   expr=true}
vim.keymap.cnoremap{'<C-k>',   'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', expr=true}

local function init_wilder()
    local command = {
        {
            [[ call wilder#set_option('pipeline', [     ]],
            [[     wilder#debounce(10),                 ]],
            [[       wilder#branch(                     ]],
            [[         wilder#cmdline_pipeline({        ]],
            [[           'fuzzy': 1,                    ]],
            [[         }),                              ]],
            [[         wilder#python_search_pipeline({  ]],
            [[           'pattern': 'fuzzy',            ]],
            [[         }),                              ]],
            [[       ),                                 ]],
            [[     ])                                   ]],
        },
        {
            [[ let highlighters = [                     ]],
            [[     wilder#basic_highlighter(),          ]],
            [[     wilder#pcre2_highlighter(),          ]],
            [[ ]                                        ]],
        },
        {
            [[ call wilder#set_option('renderer', wilder#renderer_mux({  ]],
            [[     ':': wilder#popupmenu_renderer({                      ]],
            [[         'highlighter': highlighters,                      ]],
            [[     }),                                                   ]],
            [[     '/': wilder#wildmenu_renderer({                       ]],
            [[         'highlighter': highlighters,                      ]],
            [[     }),                                                   ]],
            [[ }))                                                       ]],
        },
    }

    for _, str in pairs(command) do
        vim.cmd(table.concat(str, " "))
    end
end

-- Lazy loading the setup.
require('util').augroup{'WILDER', {
    {'CmdlineEnter', targets='*', once=true, run=init_wilder},
}}
