local lsp_util = require("plugins.lsp.util")

---@alias client 'vim.lsp.client'

---The function to pass to the LSP's on_attach callback.
---@param bufnr number
local function on_attach(_, bufnr) --{{{
  vim.api.nvim_buf_call(bufnr, function()
    lsp_util.setup_diagnostics(bufnr)
  end)
end --}}}

return {
  on_attach = on_attach,
}

-- vim: fdm=marker fdl=0
