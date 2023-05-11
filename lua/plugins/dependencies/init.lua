return {
  {
    "neovim/node-client",
    build = "npm -g install --prefix ~/.node_modules neovim@latest",
    lazy = true,
  },

  {
    "profan/lua-bk-tree",
    build = {
      "mkdir -p lua/bk-tree",
      "cp bk-tree.lua lua/bk-tree/init.lua",
    },
    lazy = true,
  },
  { import = "plugins.dependencies.go" },
  { import = "plugins.dependencies.python" },
}
