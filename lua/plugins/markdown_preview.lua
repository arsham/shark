return {
  "iamcco/markdown-preview.nvim",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  config = function()
    vim.g.mkdp_browser = "firefox"
  end,
  ft = { "markdown" },
  cond = require("util").full_start,
}
