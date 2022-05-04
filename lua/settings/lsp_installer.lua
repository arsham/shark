local lsp_installer = require("nvim-lsp-installer")

lsp_installer.setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "dockerls",
    "gopls",
    "html",
    "jedi_language_server",
    "jsonls",
    "sqls",
    "sumneko_lua",
    "tsserver",
    "vimls",
    "yamlls",
  },
  install_root_dir = vim.env.HOME .. "/.cache/lsp-servers",
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})
