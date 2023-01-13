return {
  {
    "itchyny/gojq",
    build = "go install github.com/itchyny/gojq/cmd/gojq@latest",
    lazy = true,
  },
  {
    "neovim/node-client",
    build = "npm -g install --prefix ~/.node_modules neovim@latest",
    lazy = true,
  },
  {
    "neovim/python-client",
    build = "pip3 install --user --upgrade neovim",
    lazy = true,
  },
}
