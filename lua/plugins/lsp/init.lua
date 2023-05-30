return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function() -- {{{
      vim.lsp.set_log_level("error")
    end, -- }}}
    cond = require("config.util").should_start("neovim/nvim-lspconfig"),
    enabled = require("config.util").is_enabled("neovim/nvim-lspconfig"),
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    config = function() -- {{{
      local path = require("mason-core.path")
      require("mason").setup({
        install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
        max_concurrent_installers = 4,
      })
    end, -- }}}
    lazy = true,
    cond = require("config.util").should_start("williamboman/mason.nvim"),
    enabled = require("config.util").is_enabled("williamboman/mason.nvim"),
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function() -- {{{
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers({ -- {{{
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      }) -- }}}
    end, -- }}}
    cond = require("config.util").should_start("williamboman/mason-lspconfig.nvim"),
    enabled = require("config.util").is_enabled("williamboman/mason-lspconfig.nvim"),
  },
}

-- vim: fdm=marker fdl=0
