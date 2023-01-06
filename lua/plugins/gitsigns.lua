local function config()
  ---@type Quick
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
    update_debounce = 500,
    sign_priority = 10,
    numhl = true,
    signcolumn = false,
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

    diff_opts = {
      internal = true,
      algorithm = "patience",
      indent_heuristic = true,
      linematch = 60,
    },

    on_attach = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
        return false
      end
      local size = vim.fn.getfsize(name)
      if size > 1024 * 1024 * 5 then
        return false
      end
    end,
  })

  vim.keymap.set("n", "<leader>gs", function() gitsigns.toggle_signs() end,              { desc = "toggle gitsigns sign column" })
  vim.keymap.set("n", "]c", function() quick.call_and_centre(gitsigns.next_hunk) end,    { desc = "go to next hunk" })
  vim.keymap.set("n", "[c", function() quick.call_and_centre(gitsigns.prev_hunk) end,    { desc = "go to previous hunk" })
  vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "blame line" })
  vim.keymap.set("n", "<leader>hs", function() gitsigns.stage_hunk() end,                { desc = "stage hunk" })
  vim.keymap.set("n", "<leader>hu", function() gitsigns.undo_stage_hunk() end,           { desc = "undo last staged hunk" })
  vim.keymap.set("n", "<leader>hr", function() gitsigns.reset_hunk() end,                { desc = "reset hunk" })
  vim.keymap.set("n", "<leader>hR", function() gitsigns.reset_buffer() end,              { desc = "reset buffer" })
  vim.keymap.set("n", "<leader>hp", function() gitsigns.preview_hunk() end,              { desc = "preview hunk" })
  vim.keymap.set("n", "<leader>hl", function() gitsigns.stage_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, { desc = "stage line" })
  vim.keymap.set("x", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, { desc = "stage line" })
  vim.keymap.set("x", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."),   vim.fn.line(".") }) end, { desc = "reset line" })

  -- Text objects
  local actions = require("gitsigns.actions")
  vim.keymap.set({"o", "x"}, "ih", actions.select_hunk, {desc = "in hunk"})
  vim.keymap.set({"o", "x"}, "ah", actions.select_hunk, {desc = "around hunk"})
  -- stylua: ignore end
end

return {
  "lewis6991/gitsigns.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = config,
  event = { "VeryLazy" },
  enabled = require("util").full_start,
}
