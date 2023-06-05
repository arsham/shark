return {
  "iamcco/markdown-preview.nvim",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  opts = {
    browser = "firefox",
  },
  config = function(_, opts)
    vim.g.mkdp_browser = opts.browser
  end,
  cmd = { "MarkdownPreview" },
  enabled = require("config.util").is_enabled("iamcco/markdown-preview.nvim"),
}
