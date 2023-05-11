return {
  {
    "neovim/python-client",
    build = "pip3 install --user --upgrade neovim",
    lazy = true,
  },

  {
    "pypa/pip",
    name = "Python PIP",
    build = "pip3 install --user --upgrade pip",
    cond = false,
  },
}
