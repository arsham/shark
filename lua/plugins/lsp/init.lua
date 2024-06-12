return {
  { -- LSPConfig {{{
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },

    enabled = require("config.util").is_enabled("neovim/nvim-lspconfig"),
  }, -- }}}

  { -- Mason {{{
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
    config = function()
      local path = require("mason-core.path")
      require("mason").setup({
        install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
        max_concurrent_installers = 4,
      })
    end,
    lazy = true,
    enabled = require("config.util").is_enabled("williamboman/mason.nvim"),
  }, -- }}}

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { -- {{{
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "arshlib.nvim",
      "fzfmania.nvim",
      "hrsh7th/cmp-nvim-lsp",
    }, -- }}}

    opts = function(_, opts)
      local defaults = {
        ensure_installed = { -- {{{
          "gopls",
          "rust_analyzer@nightly",
          "jsonls",
          "vimls",
          "yamlls",
          "lua_ls",
          "helm_ls",
          "bashls",
          "bufls",
          "clangd",
          "dockerls",
          "html",
          "jedi_language_server",
          "pyright",
          "sqlls",
          "taplo",
          "tsserver",
        }, -- }}}
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
          dynamicRegistration = true,
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
              dynamicRegistration = true,
            },
            callHierarchy = {
              dynamicRegistration = true,
            },
            documentSymbol = {
              dynamicRegistration = true,
            },
          },
        }, -- }}}

        server_capabilities = { -- {{{
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
            symbol = {
              dynamicRegistration = true,
            },
          },
          workspaceSymbolProvider = true,
        }, -- }}}

        servers = { -- {{{
          gopls = require("plugins.lsp.config.gopls"),
          rust_analyzer = require("plugins.lsp.config.rust_analyzer"),
          jsonls = require("plugins.lsp.config.jsonls"),
          yamlls = require("plugins.lsp.config.yamlls"),
          lua_ls = require("plugins.lsp.config.lua_ls"),
          clangd = require("plugins.lsp.config.clangd"),
        }, -- }}}
      }
      return vim.tbl_deep_extend("force", defaults, opts)
    end,

    config = function(_, opts) -- {{{
      require("mason-lspconfig").setup({
        ensure_installed = opts.ensure_installed,
        automatic_installation = true,
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local conf = opts.servers[server_name] or {}

          local ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
          if ok then
            cmp_caps = cmp_caps.default_capabilities()
          end
          local caps = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_caps or {},
            opts.capabilities or {},
            conf.capabilities or {}
          )
          conf.capabilities = caps

          local pre_attach = function(_, _) end
          if conf.on_attach ~= nil then
            pre_attach = conf.on_attach or function() end
          end
          conf.on_attach = function(client, bufnr)
            client.server_capabilities = vim.tbl_deep_extend(
              "force",
              client.server_capabilities,
              opts.server_capabilities or {},
              conf.server_capabilities or {}
            )
            pre_attach(client, bufnr)
          end

          require("lspconfig")[server_name].setup(conf)
          require("plugins.lsp.on_attach")
        end,
      })
      require("plugins.lsp.config")(opts)
    end, -- }}}
    enabled = require("config.util").is_enabled("williamboman/mason-lspconfig.nvim"),
  },

  { -- Mason Null LS {{{
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
    enabled = require("config.util").is_enabled("jay-babu/mason-null-ls.nvim"),
  }, -- }}}

  { -- Null LS {{{
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
      }
    end,

    enabled = require("config.util").is_enabled("jose-elias-alvarez/null-ls.nvim"),
  }, -- }}}

  { -- Mason Tool Installer {{{
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "delve",
          "impl",
          "rustfmt",
          "shellcheck",
        },

        auto_update = false,
      })

      vim.defer_fn(function()
        require("mason-tool-installer").run_on_start()
      end, 2000)
    end,
    enabled = require("config.util").is_enabled("WhoIsSethDaniel/mason-tool-installer.nvim"),
  }, -- }}}
}

-- vim: fdm=marker fdl=0
