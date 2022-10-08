-- vim.lsp.set_log_level("debug")

require("arshlib.tables")
local quick = require("arshlib.quick")

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
  virtual_text = false,
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
            nillness = true,
            unusedwrites = true,
            useany = true,
            unusedvariable = true,
          },
          completeUnimported = true,
          staticcheck = true,
          buildFlags = { "-tags=integration,e2e" },
          linksInHover = true,
          codelenses = {
            generate = true,
            gc_details = true,
            test = true,
            tidy = true,
            run_vulncheck_exp = true,
            upgrade_dependency = true,
          },
          usePlaceholders = true,
          directoryFilters = {
            "-**/node_modules",
            "-/tmp",
          },
          completionDocumentation = true,
          deepCompletion = true,
          semanticTokens = true,
          completionBudget = "0",
          verboseOutput = false, -- useful for debugging when true.
        },
      },
    },
  }, --}}}

  sumneko_lua = { --{{{
    opts = {},
    update = function(on_attach, opts)
      opts = require("lua-dev").setup({
        library = {
          plugins = { "arshlib.nvim", "plenary.nvim" },
        },
        runtime_path = true,
        lspconfig = {
          on_attach = on_attach,
          capabilities = opts.capabilities,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = {
                  "?/init.lua",
                  "?.lua",
                },
              },
              diagnostics = {
                globals = {
                  "vim",
                  "use",
                  "require",
                  "rocks",
                  "use_rocks",
                },
              },
              workspace = {
                ignoreDir = "tmp/",
                useGitIgnore = false,
                maxPreload = 100000000,
                preloadFileSize = 500000,
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
      local function code_action(range_given, line1, line2)
        if range_given then
          vim.lsp.buf.code_action({
            range = {
              start = { line1, 0 },
              ["end"] = { line2, 99999999 },
            },
          })
        else
          vim.lsp.buf.code_action()
        end
      end

      -- neovim's LSP client does not currently support dynamic capabilities
      -- registration.
      opts.on_attach = function(client, bufnr)
        -- sqls has a bad formatting.
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.executeCommandProvider = true
        client.server_capabilities.codeActionProvider = { resolveProvider = false }
        local sqls = require("sqls")
        sqls.on_attach(client, bufnr)
        client.commands = sqls.commands
        on_attach(client, bufnr)

        -- the picker is not compatible with fzf-lua.
        quick.buffer_command("CodeAction", function(args)
          code_action(args.range ~= 0, args.line1, args.line2)
        end, { range = true })
        local o = { desc = "SQL code action", buffer = true }
        vim.keymap.set("n", "<localleader>ca", vim.lsp.buf.code_action, o)
        vim.keymap.set("v", ":'<,'>CodeAction<CR>", "Code action", { buffer = true, silent = true })
        vim.keymap.set("n", "<C-Space>", ":SqlsExecuteQuery<CR>", { buffer = true, silent = true })
        vim.keymap.set("v", "<C-Space>", ":SqlsExecuteQuery<CR>", { buffer = true, silent = true })
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
  marksman = {},
  bufls = {},
  clangd = { --{{{
    opts = {
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    },
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
  }, --}}}

  rust_analyzer = { --{{{
    update = function(on_attach, opts)
      opts.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end
      return opts
    end,
  }, --}}}
}


local on_attach = require("settings.lsp.on_attach").on_attach

local null_ls = require("null-ls") -- NULL LS Setup {{{
null_ls.setup({
  debug = false,
  sources = {
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.prettier.with({
      disabled_filetypes = { "html" },
      extra_args = function(params)
        return params.options
          and params.options.tabSize
          and {
            "--tab-width",
            params.options.tabSize,
          }
      end,
    }),
    null_ls.builtins.formatting.stylua.with({
      extra_args = { "--indent-type=Spaces", "--indent-width=2", "--column-width=100" },
    }),
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.formatting.cbfmt.with({
      extra_args = { "--config", vim.fn.stdpath("config") .. "/scripts/cbfmt.toml" },
    }),
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.diagnostics.buf,
    null_ls.builtins.formatting.buf,
    locallinters.api_linter,
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

-- Enable (broadcasting) snippet capability for completion.
local capabilities = require("cmp_nvim_lsp").update_capabilities( --{{{
  vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true
--}}}

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  stylize_markdown = true,
  syntax = "lsp_markdown",
  border = "single",
})

-- vim: fdm=marker fdl=0
