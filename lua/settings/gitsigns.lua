local util = require('util')
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

util.nnoremap{']c', function()
  util.call_and_centre(gitsigns.next_hunk)
end, desc='go to next hunk'}
util.nnoremap{'[c', function()
  util.call_and_centre(gitsigns.prev_hunk)
end, desc='go to previous hunk'}
util.nnoremap{'<leader>hb', function()
  gitsigns.blame_line{full=true}
end, desc='blame line'}
util.nnoremap{'<leader>hs', function()
  gitsigns.stage_hunk()
end, desc='stage hunk'}
util.nnoremap{'<leader>hl', function()
  gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line(".")})
end, desc='stage line'}
util.vnoremap{'<leader>hs', function()
  gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line(".")})
end, desc='stage line'}
util.nnoremap{'<leader>hu', function()
  gitsigns.undo_stage_hunk()
end, desc='undo last staged hunk'}
util.nnoremap{'<leader>hr', function()
  gitsigns.reset_hunk()
end, desc='reset hunk'}
util.vnoremap{'<leader>hr', function()
  gitsigns.reset_hunk({vim.fn.line("."), vim.fn.line(".")})
end, desc='reset line'}
util.nnoremap{'<leader>hR', function()
  gitsigns.reset_buffer()
end, desc='reset buffer'}
util.nnoremap{'<leader>hp', function()
  gitsigns.preview_hunk()
end, desc='preview hunk'}

---Text objects
local actions = require('gitsigns.actions')
util.onoremap{'ih', actions.select_hunk, desc='in hunk'}
util.xnoremap{'ih', actions.select_hunk, desc='in hunk'}
util.onoremap{'ah', actions.select_hunk, desc='around hunk'}
util.xnoremap{'ah', actions.select_hunk, desc='around hunk'}
