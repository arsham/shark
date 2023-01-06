return {
  "woosaaahh/sj.nvim",
  event = { "VeryLazy" },
  config = function()
    local sj = require("sj")
    sj.setup({
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
    })

    vim.keymap.set("n", "<leader><leader>", sj.run, { desc = "Initiate SJ" })
  end,
}
