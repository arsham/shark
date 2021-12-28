if not pcall(require, 'astronauta.keymap') then return end
---vim.lsp.set_log_level("debug")
local util = require('util')

--Enable (broadcasting) snippet capability for completion
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = require('settings.lsp.util').on_attach

local signs = {
    Error = "🔥",
    Warn  = "💩",
    Info  = "💬",
    Hint  = "💡",
}

for type in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  local nr = "DiagnosticLineNr" .. type
    vim.fn.sign_define(hl, {
        text   = "", -- or the icon
        texthl = hl,
        linehl = "",
        numhl  = nr, -- or hl
    })
end

vim.diagnostic.config({
    virtual_text = {
        prefix = "👈",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = true,
        source    = "always",
    },
})


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local servers = {
    bashls = {},
    vimls = {},
    dockerls = {},
    jedi_language_server = {},
    html = {},
    clangd = {},
    tsserver = {},
    sqls = {},

    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                completeUnimported = true,
                staticcheck = true,
                buildFlags = {"-tags=integration,e2e"},
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
                -- allExperiments = true,
                -- formatting = {
                --      gofumpt = true,
                -- },
                usePlaceholders = true,

                completionDocumentation=true,
                deepCompletion=true,
            },
        },
    },

    jsonls =  {
        settings = {
            json = {
                schemas = require('settings.lsp.schemas').jsonls,
            },
        },
    },

    yamlls = {
        settings = {
            yaml = {
                format = { enable = true, singleQuote = true },
                validate = true,
                hover = true,
                completion = true,
                schemaStore = {
                    enable = true,
                    url = 'https://www.schemastore.org/api/json/catalog.json',
                },
                schemas = require('settings.lsp.schemas').yamlls,
            }
        }
    },
}


local lsp_status = require('lsp-status')
lsp_status.config{}

lsp_status.register_progress()
local attach_wrap = function(client, ...)
    lsp_status.on_attach(client)
    on_attach(client, ...)
end
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local conf = servers[server.name]
    if not conf then
        conf = {}
    end
    local opts = vim.tbl_deep_extend("force", {
        on_attach = attach_wrap,
        capabilities = capabilities,
    }, conf)

    if server.name == 'sumneko_lua' then
        opts = require("lua-dev").setup({
            lspconfig = {
                on_attach = attach_wrap,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim', 'use', 'require', 'rocks', 'use_rocks' },
                        },
                        workspace = {
                            maxPreload = 100000,
                            preloadFileSize = 50000,
                        },
                    }
                }
            },
        })
    elseif server.name == 'sqls' then
        local fn = function(client, ...)
            client.resolved_capabilities.execute_command = true
            client.commands = require('sqls').commands
            require('sqls').setup{
                picker = 'fzf',
            }
            attach_wrap(client, ...)
        end
        opts.on_attach = fn
    end

    -- neovim's LSP client does not currently support dynamic capabilities registration.
    if server.name == "sqls" then
        -- sqls has a bad formatting.
        opts.capabilities.document_formatting = false
        opts.on_attach = function(client, bufnr)
            client.resolved_capabilities.document_formatting = false
            attach_wrap(client, bufnr)
        end
    end

    if server.name == "jsonls" then
        opts.capabilities.document_symbol = false
        opts.capabilities.document_formatting = false
        opts.on_attach = function(client, bufnr)
            client.resolved_capabilities.document_symbol = false
            client.resolved_capabilities.document_formatting = false
            attach_wrap(client, bufnr)
        end
    end

    server:setup(opts)
end)

util.augroup{"GOPLS_GOMOD", {
    {"BufNewFile,BufRead", "go.mod", docs="don't wrap me", run=function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    end},

    {"BufWritePre", "go.mod", docs="run go mod tidy on save", run=function()
        local filename = vim.fn.expand('%:p')
        local bufnr = vim.fn.expand('<abuf>')
        require('util.lsp').go_mod_tidy(tonumber(bufnr), filename)
    end},

    {"BufRead", "go.mod", docs='check for updates', run=function()
        local filename = vim.fn.expand('<amatch>')
        require('util.lsp').go_mod_check_upgrades(filename)
    end},
}}
