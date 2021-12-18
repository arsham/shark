local util = require('util')

require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
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

    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                -- Saved for linewise pseudo object.
                -- ['al'] = '@loop.outer',
                -- ['il'] = '@loop.inner',
                ['am'] = '@call.outer',
                ['im'] = '@call.inner',
                ['ab'] = '@block.outer',
                ['ib'] = '@block.inner',
            },
        },

        move = {
            enable = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]b"] = "@block.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]B"] = "@block.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[b"] = "@block.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
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

util.augroup{"TREESITTER_LARGE_FILES", {
    {"BufRead", "*", docs="large file enhancements", run=function()
        if vim.fn.expand('%:t') == 'lsp.log' or vim.bo.filetype == 'help' then
            return
        end
        local size = vim.fn.getfsize(vim.fn.expand('%'))
        if size > 64 * 1024 then
            vim.schedule(function()
                vim.cmd[[TSBufDisable refactor.highlight_definitions]]
            end)
        end

        if size > 512 * 1024 then
            vim.schedule(function()
                vim.cmd[[TSBufDisable highlight]]
            end)
        end
    end}
}}
