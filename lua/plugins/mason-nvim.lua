local function config()
  local path = require("mason-core.path")
  require("mason").setup({
    install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
    max_concurrent_installers = 4,
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "dockerls",
      "jedi_language_server",
      "marksman",
      "rust_analyzer@nightly",
      "sqls",
      "tsserver",
      "vimls",
    },
    automatic_installation = true,
  })

  require("mason-tool-installer").setup({
    ensure_installed = {
      "autopep8",
      "buf",
      "cbfmt",
      "delve",
      "fixjson",
      "golangci-lint",
      "hadolint",
      "prettier",
      "selene",
      "shellcheck",
      "shellharden",
      "shfmt",
      "stylua",
    },

    auto_update = false,
  })

  vim.defer_fn(function()
    require("mason-tool-installer").run_on_start()
  end, 2000)

  -- Now we can setup lsp, not before!
  require("settings.lsp")
end

return {
  "williamboman/mason.nvim",
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      config = config,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "ibhagwan/fzf-lua",
        "jose-elias-alvarez/null-ls.nvim",
      },
    },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
  },
  event = { "VeryLazy" },
  enabled = require("util").full_start_with_lsp,
}
