local lsp_util = require("plugins.lsp.util")

---@alias client 'vim.lsp.client'

local server_callbacks = {}

---@param client client
local function capability_callbacks(client)
  local name = client.name
  local callbacks = server_callbacks[name]
  if callbacks then
    return callbacks
  end

  callbacks = {}
  if client.supports_method("textDocument/completion") then -- {{{
    table.insert(callbacks, function(_, buf)
      vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end)
  end -- }}}

  if client.supports_method("textDocument/hover") then -- {{{
    table.insert(callbacks, lsp_util.hover)
  end -- }}}

  if client.supports_method("textDocument/definition") then -- {{{
    table.insert(callbacks, lsp_util.goto_definition)
  end -- }}}

  server_callbacks[name] = callbacks
  return callbacks
end

---The function to pass to the LSP's on_attach callback.
---@param client client
---@param bufnr number
local function on_attach(client, bufnr) --{{{
  vim.api.nvim_buf_call(bufnr, function()
    local callbacks = capability_callbacks(client)
    for _, callback in ipairs(callbacks) do
      callback(client, bufnr)
    end

    lsp_util.setup_diagnostics(bufnr)
  end)
end --}}}

return {
  on_attach = on_attach,
}

-- vim: fdm=marker fdl=0
