local quick = require("arshlib.quick")
local gitsigns = require("gitsigns")

-- stylua: ignore start
gitsigns.setup({
  signs = {
    add          = { text = "▌", show_count = true },
    change       = { text = "▌", show_count = true },
    delete       = { text = "▐", show_count = true },
    topdelete    = { text = "▛", show_count = true },
    changedelete = { text = "▚", show_count = true },
  },
  sign_priority = 10,
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
    ["+"] = "₊",
  },
  keymaps = {},
  diff_opts = {
    internal = true,
  },
  update_debounce = 750,
})

vim.keymap.set("n", "]c", function() quick.call_and_centre(gitsigns.next_hunk) end,     {noremap=true, desc = "go to next hunk" })
vim.keymap.set("n", "[c", function() quick.call_and_centre(gitsigns.prev_hunk) end,     {noremap=true, desc = "go to previous hunk" })
vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, {noremap=true, desc = "blame line" })
vim.keymap.set("n", "<leader>hs", function() gitsigns.stage_hunk() end,                {noremap=true, desc = "stage hunk" })
vim.keymap.set("n", "<leader>hu", function() gitsigns.undo_stage_hunk() end,           {noremap=true, desc = "undo last staged hunk" })
vim.keymap.set("n", "<leader>hr", function() gitsigns.reset_hunk() end,                {noremap=true, desc = "reset hunk" })
vim.keymap.set("n", "<leader>hR", function() gitsigns.reset_buffer() end,              {noremap=true, desc = "reset buffer" })
vim.keymap.set("n", "<leader>hp", function() gitsigns.preview_hunk() end,              {noremap=true, desc = "preview hunk" })
vim.keymap.set("n", "<leader>hl", function() gitsigns.stage_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, {noremap=true, desc = "stage line" })
vim.keymap.set("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, {noremap=true, desc = "stage line" })
vim.keymap.set("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, {noremap=true, desc = "reset line" })
-- stylua: ignore end

---Text objects
local actions = require("gitsigns.actions")
vim.keymap.set("o", "ih", actions.select_hunk, { noremap = true, desc = "in hunk" })
vim.keymap.set("x", "ih", actions.select_hunk, { noremap = true, desc = "in hunk" })
vim.keymap.set("o", "ah", actions.select_hunk, { noremap = true, desc = "around hunk" })
vim.keymap.set("x", "ah", actions.select_hunk, { noremap = true, desc = "around hunk" })
