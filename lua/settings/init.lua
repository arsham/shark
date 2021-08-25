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
    -- TODO: why not enable?
    -- vim.g.completion_confirm_key = "\\<C-y>"
    -- vim.keymap.inoremap{'<CR>', MUtils.completion_confirm, {expr = true , noremap = true}}
    -- vim.api.nvim_set_keymap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
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
        vim.g.nvim_tree_icons = {
            lsp = {
                hint = "💡",
                info = "💬",
                warning = "💩",
                error = "🔥",
            },
            git = {
                deleted = "",
                ignored = "◌",
                renamed = "➜",
                staged = "✓",
                unmerged = "",
                unstaged = "",
                untracked = "★",
            },
            folder = {
                arrow_open = "▾",
                arrow_closed = "▸",
            },
        }
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

function M.treesitter_unit()
    vim.api.nvim_set_keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', {noremap=true})
    vim.api.nvim_set_keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', {noremap=true})
    vim.api.nvim_set_keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', {noremap=true})
    vim.api.nvim_set_keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', {noremap=true})
end

return M
