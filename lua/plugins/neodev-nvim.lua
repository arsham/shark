return {
  "folke/neodev.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  ft = { "lua" },
  opts = {
    library = {
      plugins = { "arshlib.nvim", "plenary.nvim", "neotest" },
      types = true,
    },
    runtime_path = true,
  },
  cond = require("config.util").should_start("folke/neodev.nvim"),
  enabled = require("config.util").is_enabled("folke/neodev.nvim"),
}
