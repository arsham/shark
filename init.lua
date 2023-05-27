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

require("config.options")

require("lazy").setup("plugins", {
  root = vim.fn.stdpath("cache") .. "/lazy",
  dev = {
    path = "~/Projects/arsham",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tohtml",
        "tutor",
      },
    },
    cache = {
      ttl = 3600 * 24,
    },
  },
  install = {
    colorscheme = { "arshamiser_dark" },
  },
  debug = false,
  readme = {
    enabled = false,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    skip_if_doc_exists = true,
  },
})
require("config.autocmd")
require("config.keymaps")
