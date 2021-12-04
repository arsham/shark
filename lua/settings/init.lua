require('astronauta.keymap')

local M = {}

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
        linear = { { '\'', '\'' }, { '"', '"' }, { '`', '`' }, { '*', '*' } },
    }
    vim.g.surround_brackets = { '(', '{', '[', '<' }

    require('surround').setup {}
end

function M.autopairs()
    local autopairs = require('nvim-autopairs')
    autopairs.setup{
        autopairs = {enable = true}
    }

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
end

M.nvim_tree = {
    setup = function()
        vim.g.nvim_tree_quit_on_open    = 1
        vim.g.nvim_tree_git_hl          = 1

        vim.g.nvim_tree_icons = {
            lsp = {
                hint    = "💡",
                info    = "💬",
                warning = "💩",
                error   = "🔥",
            },
            git = {
                deleted   = "",
                ignored   = "◌",
                renamed   = "➜",
                staged    = "✓",
                unmerged  = "",
                unstaged  = "",
                untracked = "★",
            },
            folder = {
                arrow_open   = "▾",
                arrow_closed = "▸",
            },
        }
    end,

    config = function()
        require('nvim-tree').setup {
            disable_netrw = false,
            hijack_netrw  = false,
            auto_close    = true,
            diagnostics   = {
                enable = true,
                icons = {
                    hint    = "",
                    info    = "",
                    warning = "",
                    error   = "",
                }
            },
            filters = {
                dotfiles = false,
                custom = { '.git', 'node_modules', '.cache' },
            },
        }

        vim.keymap.nnoremap{'<leader>kb', function()
            require'nvim-tree'.toggle()
        end, silent=true}
        vim.keymap.nnoremap{'<leader>kf', function()
            require'nvim-tree'.find_file(true)
        end, silent=true}
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
    require('kommentary.config').configure_language('gomod', {
        single_line_comment_string = '//',
    })
    -- vim.api.nvim_set_keymap("n", "gcc", "<Plug>kommentary_line_default", {})
    -- vim.api.nvim_set_keymap("n", "gc", "<Plug>kommentary_motion_default", {})
    -- vim.api.nvim_set_keymap("v", "gc", "<Plug>kommentary_visual_default<C-c>", {})
end

function M.treesitter_unit()
    vim.api.nvim_set_keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', {noremap=true})
    vim.api.nvim_set_keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', {noremap=true})
    vim.api.nvim_set_keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', {noremap=true})
    vim.api.nvim_set_keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', {noremap=true})
end

return M
