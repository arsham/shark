-- vim.lsp.set_log_level("debug")

local util = require("util")

local signs = {
  Error = "🔥",
  Warn = "💩",
  Info = "💬",
  Hint = "💡",
}

for type in pairs(signs) do --{{{
  local hl = "DiagnosticSign" .. type
  local nr = "DiagnosticLineNr" .. type
  vim.fn.sign_define(hl, {
    text = "", -- or the icon
    texthl = hl,
    linehl = "",
    numhl = nr, -- or hl
  })
end
--}}}
vim.diagnostic.config({ --{{{
  virtual_text = {
    prefix = "👈",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = true,
    source = "always",
  },
}) --}}}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local servers = {
  gopls = { --{{{
    opts = {
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          completeUnimported = true,
          staticcheck = true,
          buildFlags = { "-tags=integration,e2e" },
          hoverKind = "FullDocumentation",
          linkTarget = "pkg.go.dev",
          linksInHover = true,
          experimentalWorkspaceModule = true,
          experimentalPostfixCompletions = true,
          codelenses = {
            generate = true,
            gc_details = true,
            test = true,
            tidy = true,
          },
          usePlaceholders = true,

          completionDocumentation = true,
          deepCompletion = true,
        },
      },
    },
  }, --}}}

  sumneko_lua = { --{{{
    opts = {},
    update = function(on_attach, opts)
      opts = require("lua-dev").setup({
        lspconfig = {
          on_attach = on_attach,
          capabilities = opts.capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "use", "require", "rocks", "use_rocks" },
              },
              workspace = {
                maxPreload = 100000,
                preloadFileSize = 50000,
              },
            },
          },
        },
      })
      opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
      end
      return opts
    end,
  }, --}}}

  jsonls = { --{{{
    opts = {
      settings = {
        json = {
          schemas = require("settings.lsp.schemas").jsonls,
        },
      },
    },
    update = function(on_attach, opts)
      opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
      end
      return opts
    end,
  }, --}}}

  yamlls = { --{{{
    opts = {
      settings = {
        yaml = {
          format = { enable = true, singleQuote = true },
          validate = true,
          hover = true,
          completion = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = require("settings.lsp.schemas").yamlls,
        },
      },
    },
  }, --}}}

  sqls = { --{{{
    opts = {},
    update = function(on_attach, opts)
      -- neovim's LSP client does not currently support dynamic capabilities registration.
      -- sqls has a bad formatting.
      opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.executeCommandProvider = true
        client.commands = require("sqls").commands
        require("sqls").setup({ picker = "fzf" })
        on_attach(client, bufnr)
      end
      return opts
    end,
  }, --}}}

  html = { --{{{
    update = function(on_attach, opts)
      opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
      end
      return opts
    end,
  }, --}}}

  bashls = {},
  dockerls = {},
  jedi_language_server = {},
  tsserver = {},
  vimls = {},
  clangd = {
    update = function(on_attach, opts)
      opts.on_attach = function(client, bufnr)
        if vim.fn.findfile("uncrustify.cfg", ".;") ~= "" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
        on_attach(client, bufnr)
      end
      return opts
    end,
  },
  rust_analyzer = {
    update = function(on_attach, opts)
      opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end
      return opts
    end,
  },
}


-- Enable (broadcasting) snippet capability for completion.
local capabilities = require("cmp_nvim_lsp").update_capabilities( --{{{
  vim.lsp.protocol.make_client_capabilities()
)
--}}}
local on_attach = require("settings.lsp.on_attach").on_attach

local null_ls = require("null-ls") -- NULL LS Setup {{{
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.prettier.with({
      disabled_filetypes = { "html" },
    }),
    null_ls.builtins.formatting.stylua.with({
      extra_args = { "--indent-type=Spaces", "--indent-width=2", "--column-width=100" },
    }),
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.buf,
    null_ls.builtins.formatting.uncrustify.with({
      extra_args = function()
        return {
          "-c",
          vim.fn.findfile("uncrustify.cfg", ".;"),
          "--no-backup",
        }
      end,
    }),
  },
  on_attach = on_attach,
}) --}}}

local lspconfig = require("lspconfig") -- LSP Config Setup {{{
for name, server in pairs(servers) do
  local opts = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, server.opts or {})

  if server.update then
    opts = server.update(on_attach, opts)
  end
  lspconfig[name].setup(opts)
end --}}}

-- vim: fdm=marker fdl=0
