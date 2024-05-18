return {
  "stevearc/oil.nvim",
  dependencies = { "arshlib.nvim" },
  cmd = { "Oil" },
  keys = {
    { mode = "n", "<leader>oo", ":Oil<CR>", { silent = true } },
  },
  config = function()
    local oil = require("oil")
    oil.setup({
      skip_confirm_for_simple_edits = false,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    })
    local quick = require("arshlib.quick")
    quick.command("Oil", function()
      oil.open()
    end)
  end,
  enabled = require("config.util").is_enabled("stevearc/oil.nvim"),
}
