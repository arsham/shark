local path = require("mason-core.path")

require("mason").setup({
  install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
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
    "buf-language-server",
    "cbfmt",
    "delve",
    "fixjson",
    "golangci-lint",
    "hadolint",
    "prettier",
    "selene",
    "shellcheck",
    "stylua",
  },

  auto_update = false,
})

vim.defer_fn(function()
  require("mason-tool-installer").run_on_start()
end, 2000)
