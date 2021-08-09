local util = require('util')
require('astronauta.keymap')

local M = {}

function M.gitsigns()
    function PrevHunk()
        util.call_and_centre(require"gitsigns".prev_hunk)
    end
    function NextHunk()
        util.call_and_centre(require"gitsigns".next_hunk)
    end
    require('gitsigns').setup {
        signs = {
            add = {text = '▋'},
            change = {text= '▋'},
            delete = {text = '▋'},
            topdelete = {text = '▔'},
            changedelete = {text = '▎'},
        },
        keymaps = {
            ['n ]c'] = { expr = true, "&diff ? ']c' : ':lua NextHunk()<CR>'"},
            ['n [c'] = { expr = true, "&diff ? '[c' : ':lua PrevHunk()<CR>'"},

            ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

            -- Text objects
            ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
        },
    }
end

function M.treesitter()
    require('nvim-treesitter.configs').setup {
        ensure_installed = "maintained",
        indent = {enable = false},
        fold = {enable = true},
        highlight = {enable = true},

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ['al'] = '@loop.outer',
                    ['il'] = '@loop.inner',
                    ['am'] = '@call.outer',
                    ['im'] = '@call.inner',
                    ['ab'] = '@block.outer',
                    ['ib'] = '@block.inner',
                },
            },

            move = {
                enable = true,
                goto_next_start = {
                    ["]]"] = "@function.outer",
                    ["]b"] = "@block.outer",
                },
                goto_next_end = {
                    ["]["] = "@function.outer",
                    ["]B"] = "@block.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[b"] = "@block.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[B"] = "@block.outer",
                },
            },

            swap = {
                enable = true,
                swap_next = {
                    ["<leader>>a"] = "@parameter.inner",
                    ["<leader>>f"] = "@function.outer",
                    ["<leader>>e"] = "@element",
                },
                swap_previous = {
                    ["<leader><a"] = "@parameter.inner",
                    ["<leader><f"] = "@function.outer",
                    ["<leader><e"] = "@element",
                },
            },

            lsp_interop = {
                enable = true,
                peek_definition_code = {
                    -- ["<leader>df"] = "@function.outer",
                },
            },
        },
    }
end

function M.treesitter_refactor()
    require'nvim-treesitter.configs'.setup {
        refactor = {
            highlight_definitions = { enable = true },
        },
    }
end

function M.surround()
    vim.g.surround_mappings_style = 'surround'
    vim.g.surround_pairs = {
        nestable = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '<', '>' } },
        linear = { { '\'', '\'' }, { '"', '"' }, { '`', '`' } },
    }
    vim.g.surround_brackets = { '(', '{', '[', '<' }

    require('surround').setup {}
end


function M.completion()
    -- possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
    vim.g.completion_enable_snippet = 'UltiSnips'

    vim.g.completion_enable_auto_hover = 0
    vim.g.completion_enable_auto_popup = 1
    vim.g.completion_enable_auto_signature = 0
    vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
    vim.g.completion_trigger_keyword_length = 2 -- default = 1

    -- with fuzzy set, it flickers. See #237
    -- vim.g.completion_auto_change_source = 1

    vim.g.completion_chain_complete_list = {
        default = {
            default = {
                { complete_items = {'lsp', 'snippet'} },
                { mode = 'line'},
                { complete_items = {'path'}, trigger_character = {'/'} },
                { complete_items = {'buffers'} },
                { mode = 'ctrlp'},
                { mode = 'ctrln'},
            },
            comment = {
                { complete_items = {'path'}, trigger_character = {'/'} },
                { complete_items = {'buffers'} },
                { mode = 'ctrlp'},
                { mode = 'ctrln'},
                { mode = 'line'},
            },
            string = {
                complete_items = { 'path' },
            },
        },
    }

    vim.g.completion_customize_lsp_label = {
        Function  = ' [function]',
        Method    = ' [method]',
        Reference = ' [refrence]',
        Enum      = ' [enum]',
        Field     = 'ﰠ [field]',
        Keyword   = ' [key]',
        Variable  = ' [variable]',
        Folder    = ' [folder]',
        Snippet   = ' [snippet]',
        Operator  = ' [operator]',
        Module    = ' [module]',
        Text      = 'ﮜ[text]',
        Class     = ' [class]',
        Interface = ' [interface]',
        Buffers   = ' [buffers]',
        Path      = ' [path]',
    }
end

function M.autopairs()
    local autopairs = require('nvim-autopairs')
    autopairs.setup{
        autopairs = {enable = true}
    }

    _G.MUtils= {}
    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() == 0  then
            return autopairs.autopairs_cr()
        end

        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            if vim.fn.pumvisible() ~= 0  then
                return autopairs.esc("<cr>")
            end
            return autopairs.autopairs_cr()
        end

        if vim.fn.complete_info()["selected"] ~= -1 then
            require'completion'.confirmCompletion()
            return autopairs.esc("<c-y>")
        end

        vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
        require'completion'.confirmCompletion()
        return autopairs.esc("<c-n><c-y>")
    end
    -- vim.g.completion_confirm_key = "\\<C-y>"
    vim.keymap.inoremap{'<CR>', MUtils.completion_confirm, {expr = true , noremap = true}}
end


M.nvim_tree = {
    setup = function()
        vim.g.nvim_tree_disable_netrw = 0
        vim.g.nvim_tree_hijack_netrw = 0
        vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
        vim.g.nvim_tree_auto_close = 1
        vim.g.nvim_tree_quit_on_open = 1
        vim.g.nvim_tree_git_hl = 1
        vim.g.nvim_tree_lsp_diagnostics = 1
    end,
    config = function()
        vim.keymap.nmap{'<leader>kb', silent=true, ':NvimTreeToggle<CR>'}
        vim.keymap.nmap{'<leader>kf', silent=true, ':NvimTreeFindFile<CR>'}
    end
}

function M.kommentary()
    require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
    })
    require('kommentary.config').configure_language('lua', {
        single_line_comment_string = '--',
        prefer_single_line_comments = true,
    })
    -- vim.api.nvim_set_keymap("n", "gcc", "<Plug>kommentary_line_default", {})
    -- vim.api.nvim_set_keymap("n", "gc", "<Plug>kommentary_motion_default", {})
    -- vim.api.nvim_set_keymap("v", "gc", "<Plug>kommentary_visual_default<C-c>", {})
end

M.ale = {
    config = function()
        -- \ go = {'golangci-lint', 'govet', 'golint', 'remove_trailing_lines', 'trim_whitespace'}
        vim.g.ale_linters = {
            go = {'golangci-lint', 'remove_trailing_lines', 'trim_whitespace'}
        }
        -- vim.g.ale_linter_aliases = {go = {'golangci-lint'}}

        vim.g.ale_go_golangci_lint_options = '--fast --build-tags=integration,e2e'
        vim.g.ale_go_golangci_lint_package = 1
        vim.g.ale_sign_column_always = 1
        vim.g.ale_list_window_size = 5

        vim.g.ale_echo_msg_format = '%severity%: %linter%: %s'
        -- vim.g.ale_lint_on_save = 1
        vim.g.ale_lint_on_text_changed = 'always'
        -- vim.g.ale_fix_on_save = 1   -- fix files on save
        -- vim.g['powerline#extensions#ale#enabled'] = 1
        vim.g.ale_set_loclist = 1
        -- vim.g.ale_set_quickfix = 1
        vim.g.ale_open_list = 0

        vim.keymap.nnoremap{']l', silent=true, function()
            util.cmd_and_centre("ALENextWrap")
        end}
        vim.keymap.nnoremap{'[l', silent=true, function()
            util.cmd_and_centre("ALEPreviousWrap")
        end}
        vim.keymap.nnoremap{'<leader>ll', '<cmd>ALELint<CR>', silent=true}
    end,
}

function M.fzf()

    -- vim.g.fzf_action = {
    --          ['ctrl-t'] = 'tab split',
    --          ['ctrl-x'] = 'split',
    --          ['ctrl-v'] = 'vsplit',
    --          ['@'] = vim.api.nvim_exec("call function('Goto_def')", true),
    --          -- [':'] = 'call s:goto_line()',
    --          -- ['/'] = 'call s:search_file()'
    --          }

    vim.g.fzf_commands_expect = 'enter'
    vim.g.fzf_layout = { window = { width = 0.95, height = 0.95 } }
    vim.g.fzf_buffers_jump = 1          -- [Buffers] Jump to the existing window if possible
    vim.g.fzf_preview_window = {'right:50%', 'ctrl-/'}
    vim.g.fzf_commits_log_options = [[--graph --color=always
             --format="%C(yellow)%h%C(red)%d%C(reset)
             - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"]]

end

function M.wilder()
    vim.opt.wildcharm = vim.fn.char2nr('	')  -- tab
    vim.fn['wilder#enable_cmdline_enter']()
    vim.fn['wilder#set_option']('modes', {':'})

    vim.keymap.cnoremap{'<TAB>', 'wilder#in_context() ? wilder#next() : "\\<Tab>"', expr = true}
    vim.keymap.cnoremap{'<S-TAB>', 'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', expr = true}

    util.autocmd{"WILDER", {
        {"CmdlineEnter", targets="* ++once", run=WilderInit},
    }}
end


function WilderInit()
    local command = {
        {
             "call wilder#set_option('pipeline', [ ",
                 " wilder#debounce(10),",
                 "   wilder#branch(",
                 "     wilder#cmdline_pipeline({",
                 "       'fuzzy': 1,",
                 "     }),",
                 "     wilder#python_search_pipeline({",
                 "       'pattern': 'fuzzy',",
                 "     }),",
                 "   ),",
                 " ])",
         },
         {
             "let highlighters = [",
                 " wilder#basic_highlighter(),",
                 " wilder#pcre2_highlighter(),",
                 "]",
         },
         {
             "call wilder#set_option('renderer', wilder#renderer_mux({",
                 " ':': wilder#popupmenu_renderer({",
                 "   'highlighter': highlighters,",
                 " }),",
                 " '/': wilder#wildmenu_renderer({",
                 "   'highlighter': highlighters,",
                 " }),",
                 " }))",
         },
     }

     for _, str in pairs(command) do
         vim.cmd(table.concat(str, " "))
     end
end

function M.compe()
    vim.lsp.protocol.CompletionItemKind = {
        'ﮜ [text]',
        ' [method]',
        ' [function]',
        ' [constructor]',
        'ﰠ [field]',
        ' [variable]',
        ' [class]',
        ' [interface]',
        ' [module]',
        ' [property]',
        ' [unit]',
        ' [value]',
        ' [enum]',
        ' [key]',
        ' [snippet]',
        ' [color]',
        ' [file]',
        ' [reference]',
        ' [folder]',
        ' [enum member]',
        ' [constant]',
        ' [struct]',
        '⌘ [event]',
        ' [operator]',
        '⌂ [type]',
    }
end

return M
