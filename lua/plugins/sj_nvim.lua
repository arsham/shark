return {
  "woosaaahh/sj.nvim",
  event = { "VeryLazy" },
  -- stylua: ignore
  keys = {
    { mode = "n", "<leader><leader>", function() require("sj").run() end, { desc = "Initiate SJ" }},
  },
  opts = {
    pattern_type = "vim", -- lua_plain, lua, vim, vim_very_magic
    prompt_prefix = "🧲 ",
    relative_labels = true,
    separator = "",

    keymaps = {
      validate = "<CR>",
      prev_match = "<A-,>",
      next_match = "<A-;>",
      prev_pattern = "<C-p>",
      next_pattern = "<C-n>",
      send_to_qflist = "<A-q>",
    },
  },
}
