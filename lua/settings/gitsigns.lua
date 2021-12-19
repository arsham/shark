local util = require('util')
require('astronauta.keymap')
local keymap = vim.keymap
local gitsigns = require('gitsigns')

gitsigns.setup {
    signs = {
        add          = {text = '░', show_count = true},
        change       = {text = '▒', show_count = true},
        delete       = {text = '░', show_count = true},
        topdelete    = {text = '▔', show_count = true},
        changedelete = {text = '▎', show_count = true},
    },
    sign_priority = 10,
    count_chars = {
        [1]   = "",
        [2]   = "₂",
        [3]   = "₃",
        [4]   = "₄",
        [5]   = "₅",
        [6]   = "₆",
        [7]   = "₇",
        [8]   = "₈",
        [9]   = "₉",
        ["+"] = "₊"
    },
    keymaps = {},
    diff_opts = {
        internal = true,
    },
    update_debounce = 750,
}

keymap.nnoremap{']c', function() util.call_and_centre(gitsigns.next_hunk) end}
keymap.nnoremap{'[c', function() util.call_and_centre(gitsigns.prev_hunk) end}
keymap.nnoremap{'<leader>hb', function() gitsigns.blame_line{full=true} end}
keymap.nnoremap{'<leader>hs', function() gitsigns.stage_hunk() end}
keymap.nnoremap{'<leader>hl', function() gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line(".")}) end}
keymap.vnoremap{'<leader>hs', function() gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line(".")}) end}
keymap.nnoremap{'<leader>hu', function() gitsigns.undo_stage_hunk() end}
keymap.nnoremap{'<leader>hr', function() gitsigns.reset_hunk() end}
keymap.vnoremap{'<leader>hr', function() gitsigns.reset_hunk({vim.fn.line("."), vim.fn.line(".")}) end}
keymap.nnoremap{'<leader>hR', function() gitsigns.reset_buffer() end}
keymap.nnoremap{'<leader>hp', function() gitsigns.preview_hunk() end}

-- Text objects
local actions = require('gitsigns.actions')
keymap.onoremap{'ih', actions.select_hunk}
keymap.xnoremap{'ih', actions.select_hunk}
keymap.onoremap{'ah', actions.select_hunk}
keymap.xnoremap{'ah', actions.select_hunk}
