return {
  "folke/neodev.nvim",
  config = function()
    require("neodev").setup({
      library = {
        plugins = { "arshlib.nvim", "plenary.nvim", "neotest" },
        types = true,
      },
      runtime_path = true,
    })
  end,
  dependencies = { "neovim/nvim-lspconfig" },
  ft = { "lua" },
  cond = require("util").full_start_with_lsp,
}
