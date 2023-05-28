return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },

    cond = require("config.util").should_start("neovim/nvim-lspconfig"),
    enabled = require("config.util").is_enabled("neovim/nvim-lspconfig"),
  },

  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    build = ":MasonUpdate",
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "arshlib.nvim",
      "fzfmania.nvim",
    },

    opts = function(_, opts) -- {{{
      local defaults = {
        ensure_installed = {
          "gopls",
        },
        log_level = "error",
        diagnostics = { -- {{{
          signs = false,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            focusable = true,
            source = "always",
          },
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = function(diagnostic)
              local signs = require("config.icons").lsp.diagnostic.upper_signs
              local severity = vim.diagnostic.severity[diagnostic.severity]
              if signs[severity] then
                return signs[severity]
              end
              return "●"
            end,
          },
        }, -- }}}

        capabilities = { -- {{{
          textDocument = {
            completion = {
              completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = {
                  properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                  },
                },
              },
            },
          },
        }, -- }}}

        servers = {
          gopls = require("plugins.lsp.config.gopls"),
        },
      }
      return vim.tbl_deep_extend("force", defaults, opts)
    end, -- }}}

    config = function(_, opts) -- {{{
      require("mason-lspconfig").setup({
        ensure_installed = opts.ensure_installed,
        automatic_installation = true,
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local conf = opts.servers[server_name] or {}
          local caps = opts.capabilities
          if conf.capabilities then
            caps = vim.deepcopy(caps)
            conf.capabilities(caps)
          end
          conf.capabilities = caps

          local on_attach = require("plugins.lsp.on_attach").on_attach
          if conf.pre_attach then
            conf.on_attach = function(client, bufnr)
              conf.pre_attach(client, bufnr)
              on_attach(client, bufnr)
            end
          else
            conf.on_attach = on_attach
          end

          require("lspconfig")[server_name].setup(conf)
        end,
      })
      require("plugins.lsp.config")(opts)
    end, -- }}}
    cond = require("config.util").should_start("williamboman/mason-lspconfig.nvim"),
    enabled = require("config.util").is_enabled("williamboman/mason-lspconfig.nvim"),
  },
}

-- vim: fdm=marker fdl=0
