-- vim.lsp.set_log_level("debug")

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
  clangd = {},
}

local lsp_util = require("settings.lsp.util")

---@alias lsp_client 'vim.lsp.client'

---The function to pass to the LSP's on_attach callback.
---@param client lsp_client
---@param bufnr number
-- stylua: ignore start
local function on_attach(client, bufnr)--{{{
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- TODO: find out how to disable the statuline badges as well.
  if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
    vim.diagnostic.disable(bufnr)
  end

  -- TODO: turn these into: client.supports_method("textDocument/codeAction")
  vim.api.nvim_buf_call(bufnr, function()--{{{
    -- Contains functions to be run before writing the buffer. The format
    -- function will format the while buffer, and the imports function will
    -- organise imports.
    local imports_hook = function() end
    local format_hook = function() end
    local caps = client.server_capabilities

    if caps.codeActionProvider then
      lsp_util.code_action()

      -- Either is it set to true, or there is a specified set of
      -- capabilities. Sumneko doesn't support it, but the
      -- client.supports_method returns true.
      local can_organise_imports = type(caps.codeActionProvider) == "table" and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
      if can_organise_imports then
        lsp_util.setup_organise_imports()
        imports_hook = lsp_util.lsp_organise_imports
      end
    end

    if caps.documentFormattingProvider then
      lsp_util.document_formatting()
      format_hook = function() vim.lsp.buf.format({ async = false }) end
    end

    local workspace_folder_supported = caps.workspace and caps.workspace.workspaceFolders.supported
    if workspace_folder_supported           then lsp_util.workspace_folder_properties() end
    if caps.workspaceSymbolProvider         then lsp_util.workspace_symbol()            end
    if caps.hoverProvider                   then lsp_util.hover()                       end
    if caps.renameProvider                  then lsp_util.rename()                      end
    if caps.codeLensProvider                then lsp_util.code_lens()                   end
    if caps.definitionProvider              then lsp_util.goto_definition()             end
    if caps.referencesProvider              then lsp_util.find_references()             end
    if caps.declarationProvider             then lsp_util.declaration()                 end
    if caps.signatureHelpProvider           then lsp_util.signature_help()              end
    if caps.implementationProvider          then lsp_util.implementation()              end
    if caps.typeDefinitionProvider          then lsp_util.type_definition()             end
    if caps.documentSymbolProvider          then lsp_util.document_symbol()             end
    if caps.documentRangeFormattingProvider then lsp_util.document_range_formatting()   end
    if caps.callHierarchyProvider           then lsp_util.call_hierarchy()              end

    lsp_util.setup_diagnostics()
    lsp_util.setup_completions()
    lsp_util.support_commands()
    lsp_util.setup_events(imports_hook, format_hook)
    lsp_util.fix_null_ls_errors()
  end)--}}}
end--}}}
-- stylua: ignore end

local attach_wrap = function(client, ...)
  on_attach(client, ...)
end

-- Enable (broadcasting) snippet capability for completion.
local capabilities = require("cmp_nvim_lsp").update_capabilities( --{{{
  vim.lsp.protocol.make_client_capabilities()
)
--}}}

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
  on_attach = attach_wrap,
}) --}}}

local lspconfig = require("lspconfig") -- LSP Config Setup {{{
for name, server in pairs(servers) do
  local opts = vim.tbl_deep_extend("force", {
    on_attach = attach_wrap,
    capabilities = capabilities,
  }, server.opts or {})

  if server.update then
    opts = server.update(attach_wrap, opts)
  end
  lspconfig[name].setup(opts)
end --}}}

-- vim: fdm=marker fdl=0
