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
if not vim.loop.fs_stat(lazypath) then
  -- The system has no setup for git protocol.
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("config.options")

require("lazy").setup("plugins", {
  root = vim.fn.stdpath("cache") .. "/lazy",
  defaults = {
    cond = require("config.util").should_start(),
  },
  dev = {
    path = "~/Projects/arsham",
  },
  performance = {
    rtp = {
      disabled_plugins = {
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

require("config.commands")
require("config.autocmd")
require("config.keymaps")
require("config.abbreviations")
vim.schedule(function()
  vim.cmd.packadd("cfilter")
end)

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    -- fix for libuv exit error
    vim.cmd("sleep 10m")
  end,
})
