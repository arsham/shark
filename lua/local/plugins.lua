_G.MUtils= {}

require('gitsigns').setup {
    signs = {
        add = {text = '▋'},
        change = {text= '▋'},
        delete = {text = '▋'},
        topdelete = {text = '▔'},
        changedelete = {text = '▎'},
    },
}

require("lualine").setup{
    options = {
        theme = 'papercolor_light',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true,
    },

    sections = {
        lualine_a = {{'mode', {upper = true}}},
        lualine_b = {{'branch', {icon= ''}}},
        lualine_c = {{'filename', { file_status = true, full_path = true}}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location',  {'diagnostics', {sources= {'nvim_lsp', 'ale'}, color_error= '#aa0000', color_warn= '#aa0000'}}},
    },

    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {},
    },

    extensions = {'fzf'},
}


local treesitter_configs = require('nvim-treesitter.configs')

treesitter_configs.setup {
    ensure_installed = "maintained",
    indent = {enable = true},
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
}

treesitter_configs.setup {
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

        lsp_interop = {
            enable = true,
            peek_definition_code = {
                -- ["df"] = "@function.outer",
            },
        },
    },
}


local remap = vim.api.nvim_set_keymap
local autopairs = require('nvim-autopairs')
autopairs.setup{
    autopairs = {enable = true}
}

vim.g.completion_confirm_key = ""

MUtils.completion_confirm=function()
    if vim.fn.pumvisible() ~= 0  then
        if vim.fn.complete_info()["selected"] ~= -1 then
            require'completion'.confirmCompletion()
            return autopairs.esc("<c-y>")
        else
            vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
            require'completion'.confirmCompletion()
            return autopairs.esc("<c-n><c-y>")
        end
    else
        return autopairs.autopairs_cr()
    end
end

remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
