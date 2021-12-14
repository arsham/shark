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

function M.copilot()
    vim.cmd[[
    imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
    ]]
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.keymap.nnoremap{'<leader>ce', ':Copilot enable<cr>', silent=true}
    vim.keymap.nnoremap{'<leader>cd', ':Copilot disable<cr>', silent=true}
    -- disabled by default
    vim.cmd[[:Copilot disable]]
end

function M.navigator()
    local navigator = require('Navigator')
    navigator.setup()

    vim.keymap.nnoremap{"<C-h>", navigator.left,  silent=true}
    vim.keymap.nnoremap{"<C-k>", navigator.up,    silent=true}
    vim.keymap.nnoremap{"<C-l>", navigator.right, silent=true}
    vim.keymap.nnoremap{"<C-j>", navigator.down,  silent=true}
end

function M.lsp_installer()
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.settings({
        install_root_dir = vim.env.HOME .. "/.cache/lsp-servers",
        ui = {
            icons = {
                server_installed   = "✓",
                server_pending     = "➜",
                server_uninstalled = "✗"
            }
        },
    })
end

function M.visual_multi()
    vim.g.VM_theme = 'ocean'
    vim.g.VM_highlight_matches = ''
    vim.g.VM_show_warnings = 0
    vim.g.VM_silent_exit = 1
    vim.g.VM_default_mappings = 1
    vim.g.VM_maps = {
        Delete                 = 's',
        Undo                   = '<C-u>',
        Redo                   = '<C-r>',
        ['Select Operator']    = 'v',
        ['Select Cursor Up']   = '<M-C-k>',
        ['Select Cursor Down'] = '<M-C-j>',
        ['Move Left']          = '<M-C-h>',
        ['Move Right']         = '<M-C-l>',
        ['Align']              = '<M-a>',
        ['Find Under']         = '<C-n>',
        ['Find Subword Under'] = '<C-n>',
    }

    -- these don't work in the above maps.
    vim.keymap.nnoremap{[[<Leader>\]], function()
        vim.fn["vm#commands#add_cursor_at_pos"](0)
    end, {}}
    vim.keymap.nnoremap{'<Leader>A', function()
        vim.fn["vm#commands#find_all"](0, 1)
    end, {}}
end

function M.dressing()
    require('dressing').setup({
        input = {
            default_prompt = "➤ ",
            insert_only    = false,
            winblend       = 0,
        },
    })
end

function M.fugitive()
    vim.keymap.nnoremap{'<leader>gs', ':Git<cr>', silent=true}
end

return M
