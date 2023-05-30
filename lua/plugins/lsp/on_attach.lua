local lsp_util = require("plugins.lsp.util")

---@alias client 'vim.lsp.client'

---The function to pass to the LSP's on_attach callback.
---@param client client
---@param bufnr number
local function on_attach(client, bufnr) --{{{
  vim.api.nvim_buf_call(bufnr, function()
    local caps = client.server_capabilities
    if caps.completionProvider then
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    lsp_util.setup_diagnostics(bufnr)
  end)
end --}}}

return {
  on_attach = on_attach,
}

-- vim: fdm=marker fdl=0
