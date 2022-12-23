return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  event = { "LspAttach" },
  enabled = require("util").full_start_with_lsp,
}
