local lsp_installer = require("nvim-lsp-installer")

lsp_installer.settings({
  install_root_dir = vim.env.HOME .. "/.cache/lsp-servers",
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})
