if not pcall(require, 'astronauta.keymap') then return end

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
        linear = {
            { '\'', '\'' }, { '"', '"' }, { '`', '`' },
            { '|', '|' }, { '/', '/' }, { '\\', '\\' },
            { '*', '*' }, { '-', '-' }, { '+', '+' },
            { '=', '=' }, { '%', '%' }, { '$', '$' },
            { ' ', ' '},
        },
    }
    vim.g.surround_brackets = { '(', '{', '[', '<' }

    require('surround').setup {}
end

function M.autopairs()
    local autopairs = require('nvim-autopairs')
    local ts_conds = require('nvim-autopairs.ts-conds')
    local Rule = require('nvim-autopairs.rule')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    autopairs.setup{
        -- autopairs = {enable = true},
        check_ts = true,
    }

    -- press % => %% only while inside a comment or string
    autopairs.add_rules({
        Rule("%", "%", "lua")
            :with_pair(ts_conds.is_ts_node({'string','comment'})),
        Rule("$", "$", "lua")
            :with_pair(ts_conds.is_not_ts_node({'function'}))
    })

    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
end

M.nvim_tree = {
    setup = function()
        vim.g.nvim_tree_quit_on_open = 1
        vim.g.nvim_tree_git_hl       = 1
        vim.g.nvim_tree_refresh_wait = 500

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
                custom   = { '.git', 'node_modules', '.cache' },
            },
            git = {
                enable  = true,
                ignore  = false,
                timeout = 500,
            },
        }

        vim.keymap.nnoremap{'<leader>kk', function()
            require'nvim-tree'.toggle()
        end, silent=true}
        vim.keymap.nnoremap{'<leader>kf', function()
            require'nvim-tree'.find_file(true)
        end, silent=true}
        vim.keymap.nnoremap{'<leader><leader>', function()
            require'nvim-tree'.find_file(true)
        end, silent=true}
    end
}

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

function M.null_ls()
    local null_ls = require('null-ls')
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.fixjson,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.golangci_lint,
        },
    })
end

function M.Comment()
    local cmt_utils = require('Comment.utils')
    local ts_utils  = require('ts_context_commentstring.utils')
    local internal  = require('ts_context_commentstring.internal')

    require('Comment').setup {
        pre_hook = function(ctx)
            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == cmt_utils.ctype.block then
                location = ts_utils.get_cursor_location()
            elseif ctx.cmotion == cmt_utils.cmotion.v or ctx.cmotion == cmt_utils.cmotion.V then
                location = ts_utils.get_visual_start_location()
            end

            -- Detemine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == cmt_utils.ctype.line and '__default' or '__multiline'

            return internal.calculate_commentstring({
                key = type,
                location = location,
            })
        end,
    }
end

return M
