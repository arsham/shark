-- vim.lsp.set_log_level("debug")
local lspconfig = require('lspconfig')
local util = require('util')
require('astronauta.keymap')

local on_attach = require('settings.lsp.util').on_attach

--Enable (broadcasting) snippet capability for completion
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local sumneko_root_path = '/usr/bin/lua-language-server'
local sumneko_binary = "/usr/bin/lua-language-server"

local function lua_path()
    local path = vim.split(package.path, ';')
    table.insert(path, "lua/?.lua")
    table.insert(path, "lua/?/init.lua")
    return path
end

local servers = {
    bashls = {},
    vimls = {},
    dockerls = {},
    jedi_language_server = {},
    yamlls = {},
    html = {},
    ccls = {},

    tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
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
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},

        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = lua_path(),
                },

                diagnostics = {
                    globals = {
                        'vim',
                        'use',
                    },
                },

                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        [vim.fn.expand('~/.local/share/nvim/site/pack/packer')] = true,
                    },
                    maxPreload = 2000,
                    preloadFileSize = 1000,
                },

                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    },

    -- It causes vim to pause a second when it quits.
    -- sqls = {
    --     on_attach = function(client)
    --         client.resolved_capabilities.execute_command = true
    --         require'sqls'.setup{}
    --     end,
    --     picker = 'fzf'
    -- }
}

for name, conf in pairs(servers) do
    conf = vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
    }, conf)
    lspconfig[name].setup(conf)
end

-- Sets up a couple of autocmds that would stop wrapping go.mod files, and will
-- tidy and restart when the go.mod file is updated.
util.augroup{"GOPLS_GOMOD", {
    {"BufNewFile,BufRead", "go.mod", docs="don't wrap me", run=function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub('t', '')
    end},
    {"BufWritePost", "go.mod", docs="update modules", run=function()
        local job = require('plenary.job')
        job:new({
            command = "go",
            args = {"mod", "tidy"},
            on_exit = function(j, exit_code)
                local res = table.concat(j:result(), "\n")
                if #res == 0 then
                    res = "Everything is caught up"
                end

                local type = vim.lsp.log_levels.INFO
                local timeout = 3000

                if exit_code ~=0 then
                    type = vim.lsp.log_levels.ERROR
                    res = table.concat(j:stderr_result(), "\n")
                    timeout = 10000
                end

                vim.notify(res, type, {
                    title = "Go Module Updates",
                    timeout = timeout,
                })
                vim.schedule(function()
                    vim.cmd[[RestartLsp]]
                end)
            end,
        }):start()
    end},
}}


-- vim.cmd("let g:completion_expand_characters = [' ', '\t', '>', ';', ')']")
lspconfig.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {"gopls", "serve"},

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
            -- matcher = "CaseInsensitive",
        },
    },
}
