" :lua << EOF
"     local nvim_lsp = require('lspconfig')
"     local on_attach = function(client, bufnr)
"         -- require('completion').on_attach()
"
"         local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"
"         local opts = { noremap=true, silent=true }
"         buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"         buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"         buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
"
"         require'lspconfig'.gopls.setup{}
"     end
"     local servers = { 'gopls' }
"     for _, lsp in ipairs(servers) do
"         nvim_lsp[lsp].setup {
"             on_attach = on_attach,
"         }
"     end
" EOF
