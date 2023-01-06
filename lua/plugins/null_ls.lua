return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  event = { "LspAttach" },
  cond = require("util").full_start_with_lsp,
}
