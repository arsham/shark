vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("cache") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "git@github.com:folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("options")
require("lazy").setup("plugins", {
  root = vim.fn.stdpath("cache") .. "/lazy",
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
  debug = false,
})

require("commands")
require("autocmd")
require("mappings")
require("textobjects")
require("scratch")
