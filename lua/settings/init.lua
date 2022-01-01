local nvim = require('nvim')
local util = require('util')

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
        check_ts = true,
        --- will ignore alphanumeric and `.` symbol
        ignored_next_char = "[%w%.]",
    }
    autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
    --- press % => %% only while inside a comment or string
    autopairs.add_rules({
        Rule("|", "|", "lua")
            :with_pair(ts_conds.is_ts_node({'string','comment'})),
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

        util.nnoremap{'<leader>kk', function()
            require'nvim-tree'.toggle()
        end, silent=true, desc='Toggle tree view'}
        util.nnoremap{'<leader>kf', function()
            require'nvim-tree'.find_file(true)
        end, silent=true, desc='Find file in tree view'}
        util.nnoremap{'<leader><leader>', function()
            require'nvim-tree'.toggle()
        end, silent=true, desc='Toggle tree view'}
    end
}

function M.treesitter_unit()
    util.xnoremap{'iu', ':lua require"treesitter-unit".select()<CR>',          desc='select in unit'}
    util.xnoremap{'au', ':lua require"treesitter-unit".select(true)<CR>',      desc='select around unit'}
    util.onoremap{'iu', ':<c-u>lua require"treesitter-unit".select()<CR>',     desc='select in unit'}
    util.onoremap{'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', desc='select around unit'}
end

function M.copilot()
    util.imap{'<C-y>', [[copilot#Accept("\<CR>")]], silent=true, expr=true, script=true, desc='copilot accept suggestion'}
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    util.nnoremap{'<leader>ce', ':Copilot enable<cr>',  silent=true, desc='enable copilot'}
    util.nnoremap{'<leader>cd', ':Copilot disable<cr>', silent=true, desc='disable copilot'}
    --- disabled by default
    nvim.ex.Copilot('disable')
end

function M.navigator()
    local navigator = require('Navigator')
    navigator.setup()

    util.nnoremap{"<C-h>", navigator.left,  silent=true, desc='navigate to left window or tmux pane'}
    util.nnoremap{"<C-k>", navigator.up,    silent=true, desc='navigate to upper window or tmux pane'}
    util.nnoremap{"<C-l>", navigator.right, silent=true, desc='navigate to right window or tmux pane'}
    util.nnoremap{"<C-j>", navigator.down,  silent=true, desc='navigate to lower window or tmux pane'}
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

    --- these don't work in the above maps.
    util.nnoremap{[[<Leader>\]], function()
        vim.fn["vm#commands#add_cursor_at_pos"](0)
    end, desc='add cursor at position'}
    util.nnoremap{'<Leader>A', function()
        vim.fn["vm#commands#find_all"](0, 1)
    end, desc='find all matches'}
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
    util.nnoremap{'<leader>gg', ':Git<cr>', silent=true, desc='open fugitive'}
end

function M.null_ls()
    local null_ls = require('null-ls')
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.fixjson,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.golangci_lint,
        },
        on_attach = function(client)
            if client.resolved_capabilities.document_formatting then
                util.autocmd{'BufWritePre', run=function() vim.lsp.buf.formatting_sync() end, buffer=true}
            end
            if client.resolved_capabilities.document_range_formatting then
                util.buffer_command('Format', function(args)
                    require("settings.lsp.util").format_command(args.range ~= 0, args.line1, args.line2, args.bang)
                end, {range=true})
                util.vnoremap{"gq", ':Format<CR>', buffer=true, silent=true, desc='format range'}
                vim.bo.formatexpr = 'v:lua.vim.lsp.formatexpr()'
            end
        end,
    })
end

function M.Comment()
    local cmt_utils = require('Comment.utils')
    local ts_utils  = require('ts_context_commentstring.utils')
    local internal  = require('ts_context_commentstring.internal')

    require('Comment').setup {
        pre_hook = function(ctx)
            --- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == cmt_utils.ctype.block then
                location = ts_utils.get_cursor_location()
            elseif ctx.cmotion == cmt_utils.cmotion.v or ctx.cmotion == cmt_utils.cmotion.V then
                location = ts_utils.get_visual_start_location()
            end

            --- Detemine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == cmt_utils.ctype.line and '__default' or '__multiline'

            return internal.calculate_commentstring({
                key = type,
                location = location,
            })
        end,
    }
end

return M
