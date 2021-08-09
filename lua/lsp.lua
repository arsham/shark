-- vim.lsp.set_log_level("debug")
local lspconfig = require 'lspconfig'
local util = require 'util'
require('astronauta.keymap')

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

util.highlight("LspReferenceRead", {ctermbg=180, guibg='#43464F', style='bold'})
util.highlight("LspReferenceText", {ctermbg=180, guibg='#43464F', style='bold'})
util.highlight("LspReferenceWrite", {ctermbg=180, guibg='#43464F', style='bold'})


local function lspBufferMappings()
    vim.keymap.nnoremap{'gd',         vim.lsp.buf.definition,          silent = true}
    vim.keymap.nnoremap{'gD',         vim.lsp.buf.declaration,         silent = true}
    vim.keymap.nnoremap{'gr',         vim.lsp.buf.references,          silent = true}
    vim.keymap.nnoremap{'<leader>gi', vim.lsp.buf.implementation,      silent = true}
    vim.keymap.nnoremap{'H',          vim.lsp.buf.hover,               silent = true}
    vim.keymap.nnoremap{'K',          vim.lsp.buf.signature_help,      silent = true}
    vim.keymap.inoremap{'<C-k>',      vim.lsp.buf.signature_help,      silent = true}

    vim.keymap.inoremap{'<Tab>',      require"completion".smart_tab,   silent = true}
    vim.keymap.inoremap{'<S-Tab>',    require"completion".smart_s_tab, silent = true}
    vim.keymap.inoremap{'<c-j>',      require"completion".nextSource,  silent = true} -- "use <c-j> to switch to next completion
    vim.keymap.inoremap{'<c-k>',      require"completion".prevSource,  silent = true} -- "use <c-k> to switch to previous completion

    vim.keymap.nnoremap{'<leader>dd', vim.lsp.diagnostic.show_line_diagnostics, silent = true}
    vim.keymap.nnoremap{'<leader>dq', vim.lsp.diagnostic.set_loclist,           silent = true}

    vim.keymap.nnoremap{']d', silent = true, function()
        util.call_and_centre(vim.lsp.diagnostic.goto_next)
    end}
    vim.keymap.nnoremap{'[d', silent = true, function()
        util.call_and_centre(vim.lsp.diagnostic.goto_prev)
    end}

    -- local function buf_set_keymap_expr(mode, key, result)
    --     vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true, expr = true})
    -- end
    -- Use <Tab> and <S-Tab> to navigate through popup menu
    -- buf_set_keymap_expr('i', '<Tab>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"')
    -- buf_set_keymap_expr('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')
end

local on_attach = function(client)
    require 'completion'.on_attach()
    -- require'lsp_signature'.on_attach()

    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    lspBufferMappings()

    -- local opts = { noremap=true, silent=true }

    if client.resolved_capabilities.code_action then
        util.autocmd{"LSP_ORGANISE_IMPORTS", {
            {"BufWritePre", buffer=true, run=LspOrganiseImports},
        }}
    end

    if client.resolved_capabilities.document_formatting then
        vim.keymap.nnoremap{"<leader>gq", vim.lsp.buf.formatting}
        util.autocmd{"LSP_FORMATTING", {
            {"BufWritePre", silent=true, buffer=true, run=function()
                vim.lsp.buf.formatting_sync(nil, 500)
            end},
        }}
    end

    if client.resolved_capabilities.document_range_formatting then
        vim.keymap.vnoremap{"gq", vim.lsp.buf.range_formatting}
    end

    -- Let's have treesitter take care of this instead.
    -- if client.resolved_capabilities.document_highlight then
    --     vim.cmd([[
    --         augroup LSP_DOCUMENT_HIGHLIGHT
    --             autocmd! * <buffer>
    --             autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    --             autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    --             autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    --             autocmd CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
    --             autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false, show_header = false, border = 'single'})
    --         augroup END
    --     ]])
    -- end
end


lspconfig.bashls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.vimls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.dockerls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.yamlls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.html.setup{
    capabilities = capabilities,
}

lspconfig.tsserver.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "typescript-language-server", "--stdio" },
}

-- It causes vim to pause a second when it quits.
-- lspconfig.sqls.setup{
--     on_attach = function(client)
--         client.resolved_capabilities.execute_command = true
--         require'sqls'.setup{}
--     end,
--     picker = 'fzf'
-- }

lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
        }
    }
}

local sumneko_root_path = '/usr/bin/lua-language-server'
local sumneko_binary = "/usr/bin/lua-language-server"

local function lua_path()
  local path = vim.split(package.path, ';')
  table.insert(path, "lua/?.lua")
  table.insert(path, "lua/?/init.lua")
  return path
end

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},

    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                -- path = vim.split(lua_path(), ';'),
                -- path = vim.split(package.path,';'),
                path = lua_path(),
            },

            diagnostics = {
                globals = {'vim'},
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
}

-- vim.cmd("let g:completion_expand_characters = [' ', '\t', '>', ';', ')']")
lspconfig.gopls.setup{
    on_attach = on_attach,
    -- capabilities = capabilities, -- causes weird argument listings
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


function LspOrganiseImports()
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "table", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local timeout = 1000 -- ms

    local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
    if not resp then return end

    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if resp[client.id] then
            local result = resp[client.id].result
            if not result or not result[1] then return end

            local edit = result[1].edit
            vim.lsp.util.apply_workspace_edit(edit)
        end
    end
end
