return {
  {
    "neovim/node-client",
    build = "npm -g install --prefix ~/.node_modules neovim@latest",
    lazy = true,
  },

  { import = "plugins.dependencies.go" },
  { import = "plugins.dependencies.python" },
}
