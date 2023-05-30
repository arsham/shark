return {
  "kosayoda/nvim-lightbulb",
  opts = {
    sign = {
      enabled = false,
    },
    float = {
      enabled = false,
    },
    virtual_text = {
      enabled = true,
      text = "💡",
      -- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
      hl_mode = "replace",
    },
    autocmd = { enabled = true },
  },

  event = { "LspAttach" },
  cond = require("config.util").should_start("kosayoda/nvim-lightbulb"),
  enabled = require("config.util").is_enabled("kosayoda/nvim-lightbulb"),
}
