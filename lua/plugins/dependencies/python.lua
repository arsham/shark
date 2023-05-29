return {
  {
    "pypa/pip",
    name = "Python PIP",
    build = "pip3 install --user --upgrade pip",
    cond = false,
  },

  {
    "neovim/python-client",
    build = "pip3 install --user --upgrade neovim",
    lazy = true,
  },
}
