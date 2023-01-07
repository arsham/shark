return {
  "folke/neodev.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  ft = { "lua" },
  cond = require("util").full_start_with_lsp,
  config = {
    library = {
      plugins = { "arshlib.nvim", "plenary.nvim", "neotest" },
      types = true,
    },
    runtime_path = true,
  },
}
