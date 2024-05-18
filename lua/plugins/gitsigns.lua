return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = { "BufReadPost", "BufNewFile" },
  keys = { -- {{{
    { mode = { "n" }, "<leader>gs" },
    { mode = { "n" }, "<leader>hb" },
    { mode = { "n" }, "<leader>hs" },
    { mode = { "n" }, "<leader>hu" },
    { mode = { "n" }, "<leader>hr" },
    { mode = { "n" }, "<leader>hR" },
    { mode = { "n" }, "<leader>hp" },
    { mode = { "n" }, "<leader>hl" },
    { mode = { "x" }, "<leader>hs" },
    { mode = { "x" }, "<leader>hr" },

    -- Text objects
    { mode = { "o", "x" }, "ih" },
    { mode = { "o", "x" }, "ah" },
  }, -- }}}

  config = function()
    local gs = require("gitsigns")
    local quick = require("arshlib.quick")
    local constants = require("config.constants")

    gs.setup({
      -- stylua: ignore
      signs = { -- {{{
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
        if size > constants.large_file_size then
          return false
        end
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>gs", function() gs.toggle_signs() end, { desc = "toggle gitsigns sign column" })
        vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "blame line" })
        vim.keymap.set("n", "<leader>hs", function() gs.stage_hunk() end, { desc = "stage hunk" })
        vim.keymap.set("n", "<leader>hu", function() gs.undo_stage_hunk() end, { desc = "undo last staged hunk" })
        vim.keymap.set("n", "<leader>hr", function() gs.reset_hunk() end, { desc = "reset hunk" })
        vim.keymap.set("n", "<leader>hR", function() gs.reset_buffer() end, { desc = "reset buffer" })
        vim.keymap.set("n", "<leader>hp", function() gs.preview_hunk() end, { desc = "preview hunk" })
        vim.keymap.set("n", "<leader>hl", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "stage line" })
        vim.keymap.set("x", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "stage line" })
        vim.keymap.set("x", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line(".") }) end, { desc = "reset line" })

        -- Text objects
        vim.keymap.set({ "o", "x" }, "ih", function() require("gitsigns.actions").select_hunk() end, { desc = "in hunk" })
        vim.keymap.set({ "o", "x" }, "ah", function() require("gitsigns.actions").select_hunk() end, { desc = "around hunk" })

        local next_hunk = gs.next_hunk
        local prev_hunk = gs.prev_hunk
        local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
        if ok then
          next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
        end
        vim.keymap.set({ "n", "x" }, "]c", function() quick.call_and_centre(next_hunk) end, { desc = "go to next change" })
        vim.keymap.set({ "n", "x" }, "[c", function() quick.call_and_centre(prev_hunk) end, { desc = "go to previous change" })
        -- stylua: ignore end
      end, -- }}}
    })
  end,
  enabled = require("config.util").is_enabled("lewis6991/gitsigns.nvim"),
}

-- vim: fdm=marker fdl=0
