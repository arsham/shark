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
      "hrsh7th/cmp-nvim-lsp",
    },

    opts = function(_, opts) -- {{{
      local defaults = {
        ensure_installed = {
          "gopls",
          "rust_analyzer@nightly",
          "jsonls",
          "vimls",
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
          rust_analyzer = require("plugins.lsp.config.rust_analyzer"),
          jsonls = require("plugins.lsp.config.jsonls"),
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
          if not conf.capabilities then
            conf.capabilities = function(_) end
          end

          local caps = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities(),
            opts.capabilities or {}
          )
          conf.capabilities(caps)
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

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },
    event = { "BufRead", "BufNewFile" },
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    },
    cond = require("config.util").should_start("jay-babu/mason-null-ls.nvim"),
    enabled = require("config.util").is_enabled("jay-babu/mason-null-ls.nvim"),
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        debug = false,
        sources = {
          -- Formatters run in the shown order.

          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.selene,

          null_ls.builtins.formatting.autopep8,
          null_ls.builtins.formatting.buf,
          null_ls.builtins.formatting.cbfmt.with({
            extra_args = { "--config", vim.fn.stdpath("config") .. "/scripts/cbfmt.toml" },
          }),
          null_ls.builtins.formatting.fixjson,
          null_ls.builtins.formatting.prettier.with({
            disabled_filetypes = { "html" },
            extra_args = function(params)
              return params.options
                and params.options.tabSize
                and { "--tab-width", params.options.tabSize }
            end,
          }),
          null_ls.builtins.formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type=Spaces", "--indent-width=2", "--column-width=100" },
          }),
          null_ls.builtins.formatting.uncrustify.with({
            extra_args = function()
              return { "-c", vim.fn.findfile("uncrustify.cfg", ".;"), "--no-backup" }
            end,
          }),
        },
        root_dir = require("null-ls.utils").root_pattern(
          ".null-ls-root",
          ".neoconf.json",
          "Makefile",
          ".git"
        ),
        on_attach = require("plugins.lsp.on_attach").on_attach,
      }
    end,

    cond = require("config.util").should_start("jose-elias-alvarez/null-ls.nvim"),
    enabled = require("config.util").is_enabled("jose-elias-alvarez/null-ls.nvim"),
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-tool-installer").setup({ -- {{{
        ensure_installed = {
          "delve",
          "impl",
          "rustfmt",
          "shellcheck",
          "shellharden",
        },

        auto_update = false,
      }) -- }}}
    end,
  },
}

-- vim: fdm=marker fdl=0
