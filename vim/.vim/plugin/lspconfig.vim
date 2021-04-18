" npm -g i --prefix ~/.node_modules bash-language-server
" npm -g i --prefix ~/.node_modules vim-language-server
" npm -g i --prefix ~/.node_modules dockerfile-language-server-nodejs
" npm -g i --prefix ~/.node_modules vscode-html-languageserver-bin
" npm -g i --prefix ~/.node_modules vscode-json-languageserver
" npm -g i --prefix ~/.node_modules pyright
" npm -g i --prefix ~/.node_modules yaml-language-server
" go install github.com/lighttiger2505/sqls@latest
" yay -S lua-language-server-git
" go get github.com/nametake/golangci-lint-langserver


lua << EOF
-- vim.lsp.set_log_level("debug")
local lspconfig = require 'lspconfig'

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup{
    capabilities = capabilities,
}

local on_attach = function(client, bufnr)
    require 'completion'.on_attach()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        vim.api.nvim_exec([[
            augroup formatting
                autocmd! * <buffer>
                autocmd BufWritePre * silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
            augroup END
        ]], false)
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("v", "gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    vim.api.nvim_exec([[
        hi LspReferenceRead ctermbg=180 guibg=#43464F gui=bold
        hi LspReferenceText ctermbg=180 guibg=#43464F gui=bold
        hi LspReferenceWrite ctermbg=180 guibg=#43464F gui=bold
    ]], false)
    if client.resolved_capabilities.document_highlight then
        -- vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                autocmd CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end
end


lspconfig.bashls.setup{ on_attach = on_attach }
lspconfig.vimls.setup{ on_attach = on_attach }
lspconfig.dockerls.setup{ on_attach = on_attach }
lspconfig.pyright.setup{ on_attach = on_attach }
lspconfig.yamlls.setup{ on_attach = on_attach }

lspconfig.jsonls.setup {
    on_attach = on_attach,
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

--- settings for sumneko lua lsp
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/usr/bin/lua-language-server'
local sumneko_binary = "/usr/bin/lua-language-server"

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

--- gopls
lspconfig.gopls.setup{
    on_attach = on_attach,
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
            -- workspaceFolders = true,
            allExperiments = true,
            -- formatting = {
            --      gofumpt = true,
            -- },
            usePlaceholders = true,
        },
    },
}

-- local servers = {"sumneko_lua",  "jsonls", "html", "yamlls", "pyright", "dockerls", "vimls", "bashls"}
-- -- local servers = {"sumneko_lua", "gopls", "jsonls", "html", "yamlls", "pyright", "dockerls", "vimls", "bashls"}
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup { on_attach = on_attach }
-- end

EOF
