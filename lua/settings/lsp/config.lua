-- vim.lsp.set_log_level("debug")
local util = require('util')
require('astronauta.keymap')

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
    severity_sort = false,
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
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
                end
            }
        }
    },

    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },

                diagnostics = {
                    globals = { 'vim', 'use', 'require', 'rocks', 'use_rocks' },
                },

                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        [vim.fn.expand('~/.local/share/nvim/site/pack/packer')] = true,
                    },
                    -- library = vim.api.nvim_get_runtime_file("", true),
                    maxPreload = 2000,
                    preloadFileSize = 1000,
                },

                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        }
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
                schemas = {
                    kubernetes = {
                        'templates/*.yaml',
                        'helm/*.yaml',
                        'kube/*.yaml',
                    },
                    ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
                    ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
                    ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
                    ['http://json.schemastore.org/ansible-playbook'] = 'playbook.{yml,yaml}',
                    ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
                    ['http://json.schemastore.org/stylelintrc'] = '.stylelintrc.{yml,yaml}',
                    ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
                    ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
                    ['http://json.schemastore.org/helmfile'] = 'helmfile.{yml,yaml}',
                    ['http://json.schemastore.org/gitlab-ci'] = '/*lab-ci.{yml,yaml}',
                }
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

    if server.name == 'sqls' then
        local fn = function(client, ...)
            client.resolved_capabilities.execute_command = true
            client.commands = require('sqls').commands -- Neovim 0.6+ only
            require('sqls').setup{
                picker = 'fzf',
            }
            attach_wrap(client, ...)
        end
        opts.on_attach = fn
    end
    server:setup(opts)
end)

-- Sets up a couple of autocmds that would stop wrapping go.mod files, and will
-- tidy and restart when the go.mod file is updated.
util.augroup{"GOPLS_GOMOD", {
    {"BufNewFile,BufRead", "go.mod", docs="don't wrap me", run=function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    end},
    {"BufWritePost", "go.mod", docs="run go mod tidy on save", run=function()
        local job = require('plenary.job')
        job:new({
            command = "go",
            args = {"mod", "tidy"},
            on_exit = function(j, exit_code)
                local res = table.concat(j:result(), "\n")
                if #res == 0 then
                    res = "Everything is tidy now"
                end

                local type = vim.lsp.log_levels.INFO
                local timeout = 3000

                if exit_code ~=0 then
                    type = vim.lsp.log_levels.ERROR
                    res = table.concat(j:stderr_result(), "\n")
                    timeout = 10000
                end

                vim.schedule(function()
                    vim.cmd[[RestartLsp]]
                end)
                vim.notify(res, type, {
                    title = "Go Modules Are Tidy Now",
                    timeout = timeout,
                })
            end,
        }):start()
    end},
}}
