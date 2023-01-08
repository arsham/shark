return {
  "lewis6991/gitsigns.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  event = { "VeryLazy" },
  cond = require("util").full_start,
  -- stylua: ignore
  keys = {-- {{{
    { mode = { "n" }, "<leader>gs", function() require("gitsigns").toggle_signs() end, { desc = "toggle gitsigns sign column" } },
    { mode = { "n" }, "]c",         function() require("arshlib.quick").call_and_centre(require("gitsigns").next_hunk) end, { desc = "go to next hunk" } },
    { mode = { "n" }, "[c",         function() require("arshlib.quick").call_and_centre(require("gitsigns").prev_hunk) end, { desc = "go to previous hunk" } },
    { mode = { "n" }, "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "blame line" } },
    { mode = { "n" }, "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "stage hunk" } },
    { mode = { "n" }, "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, { desc = "undo last staged hunk" } },
    { mode = { "n" }, "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "reset hunk" } },
    { mode = { "n" }, "<leader>hR", function() require("gitsigns").reset_buffer() end, { desc = "reset buffer" } },
    { mode = { "n" }, "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "preview hunk" } },
    { mode = { "n" }, "<leader>hl", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "stage line" } },
    { mode = { "x" }, "<leader>hs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "stage line" } },
    { mode = { "x" }, "<leader>hr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "reset line" } },

    -- Text objects
    { mode = { "o", "x" }, "ih",    function() require("gitsigns.actions").select_hunk() end, { desc = "in hunk" } },
    { mode = { "o", "x" }, "ah",    function() require("gitsigns.actions").select_hunk() end, { desc = "around hunk" } },
  }, -- }}}

  opts = {
    -- stylua: ignore
    signs = {-- {{{
      add          = { text = "▌", show_count = true },
      change       = { text = "▌", show_count = true },
      delete       = { text = "▐", show_count = true },
      topdelete    = { text = "▛", show_count = true },
      changedelete = { text = "▚", show_count = true },
    }, -- }}}
    update_debounce = 500,
    sign_priority = 10,
    numhl = true,
    signcolumn = false,
    count_chars = { -- {{{
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
    }, -- }}}

    diff_opts = { -- {{{
      internal = true,
      algorithm = "patience",
      indent_heuristic = true,
      linematch = 60,
    }, -- }}}

    on_attach = function(bufnr) -- {{{
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
        return false
      end
      local size = vim.fn.getfsize(name)
      if size > 1024 * 1024 * 5 then
        return false
      end
    end, -- }}}
  },
}

-- vim: fdm=marker fdl=0
