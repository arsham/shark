local util = require('util')
require('astronauta.keymap')
local keymap = vim.keymap

require('gitsigns').setup {
    signs = {
        add = {text = '▋'},
        change = {text= '▋'},
        delete = {text = '▋'},
        topdelete = {text = '▔'},
        changedelete = {text = '▎'},
    },
    sign_priority = 1,
    count_chars = {
        [1] = "",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ["+"] = "₊"
    },
    keymaps = {},
    use_internal_diff = false,
}

keymap.nnoremap{']c', function() util.call_and_centre(require"gitsigns".next_hunk) end}
keymap.nnoremap{'[c', function() util.call_and_centre(require"gitsigns".prev_hunk) end}
keymap.nnoremap{'<leader>hb', function() require("gitsigns").blame_line(true) end}
keymap.nnoremap{'<leader>hs', function() require("gitsigns").stage_hunk() end}
keymap.vnoremap{'<leader>hS', function() require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end}
keymap.nnoremap{'<leader>hu', function() require("gitsigns").undo_stage_hunk() end}
keymap.nnoremap{'<leader>hr', function() require("gitsigns").reset_hunk() end}
keymap.vnoremap{'<leader>hr', function() require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end}
keymap.nnoremap{'<leader>hR', function() require("gitsigns").reset_buffer() end}
keymap.nnoremap{'<leader>hp', function() require("gitsigns").preview_hunk() end}

-- Text objects
keymap.onoremap{'ih', require"gitsigns.actions".select_hunk}
keymap.xnoremap{'ih', require"gitsigns.actions".select_hunk}
