return {
  "aduros/ai.vim",
  init = function()
    vim.g.ai_no_mappings = true
    vim.g.ai_temperature = 0.7
    vim.g.ai_indicator_text = "󱚠"
  end,
  keys = {
    { mode = { "i" }, "<C-a>", "<Esc>:AI<CR>a", { silent = true } },
    { mode = { "n" }, "<M-a>", ":AI", { silent = true } },
    {
      mode = { "v" },
      "<M-c>",
      ":AI Corrects sentences into standard English.<CR>",
      { desc = "Grammar check", silent = true },
    },
  },
  cmd = { "AI" },
  cond = require("config.util").should_start("aduros/ai.vim"),
  enabled = require("config.util").is_enabled("aduros/ai.vim"),
}
