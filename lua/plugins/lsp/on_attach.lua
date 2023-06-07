local lsp_util = require("plugins.lsp.util")

local server_callbacks = {}

---@param client lspclient
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

  if client.supports_method("textDocument/signatureHelp") then -- {{{
    table.insert(callbacks, lsp_util.signature_help)
  end -- }}}

  -- Contains functions to be run before writing the buffer. The format
  -- function will format the while buffer, and the imports function will
  -- organise imports.
  local imports_hook = function() end
  local format_hook = function() end
  local caps = client.server_capabilities
  if client.supports_method("textDocument/codeAction") then -- {{{
    table.insert(callbacks, lsp_util.code_action)

    -- Either is it set to true, or there is a specified set of
    -- capabilities. Sumneko doesn't support it, but the
    -- client.supports_method returns true.
    local can_organise_imports = type(caps.codeActionProvider) == "table"
      and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
    if can_organise_imports then
      table.insert(callbacks, lsp_util.setup_organise_imports)
      imports_hook = lsp_util.lsp_organise_imports
    end
  end -- }}}

  if client.supports_method("textDocument/formatting") then -- {{{
    table.insert(callbacks, lsp_util.document_formatting)
    format_hook = function()
      vim.lsp.buf.format({
        async = false,
      })
    end
  end -- }}}

  if client.supports_method("textDocument/rangeFormatting") then -- {{{
    local disabled_servers = {}
    table.insert(callbacks, function()
      lsp_util.document_range_formatting(disabled_servers)
    end)
  end -- }}}

  -- Setup import format eveents {{{
  table.insert(callbacks, function(cl, bufnr)
    lsp_util.setup_events(cl, imports_hook, format_hook, bufnr)
  end) -- }}}

  local workspace_folder_supported = caps.workspace -- {{{
    and caps.workspace.workspaceFolders
    and caps.workspace.workspaceFolders.supported
  if workspace_folder_supported then
    table.insert(callbacks, lsp_util.workspace_folder_properties)
  end -- }}}

  if client.supports_method("workspace/symbol") then -- {{{
    table.insert(callbacks, lsp_util.workspace_symbol)
  end -- }}}

  if client.supports_method("textDocument/documentSymbol") then -- {{{
    table.insert(callbacks, lsp_util.document_symbol)
  end -- }}}

  if client.supports_method("textDocument/rename") then -- {{{
    table.insert(callbacks, lsp_util.rename)
  end -- }}}

  if client.supports_method("textDocument/references") then -- {{{
    table.insert(callbacks, lsp_util.find_references)
  end -- }}}

  if client.supports_method("textDocument/implementation") then -- {{{
    table.insert(callbacks, lsp_util.implementation)
  end -- }}}

  if client.supports_method("textDocument/typeDefinition") then -- {{{
    table.insert(callbacks, lsp_util.type_definition)
  end -- }}}

  if client.supports_method("textDocument/declaration") then -- {{{
    table.insert(callbacks, lsp_util.declaration)
  end -- }}}

  -- Code lenses {{{
  if
    client.supports_method("textDocument/codeLens") or client.supports_method("codeLens/resolve")
  then
    table.insert(callbacks, lsp_util.code_lens)
  end -- }}}

  -- Code hierarchy {{{
  if
    client.supports_method("textDocument/prepareCallHierarchy")
    or client.supports_method("callHierarchy/incomingCalls")
    or client.supports_method("callHierarchy/outgoingCalls")
  then
    table.insert(callbacks, lsp_util.call_hierarchy)
  end -- }}}

  -- Semantic Tokens {{{
  if client.supports_method("textDocument/semanticTokens") and vim.lsp.semantic_tokens then
    table.insert(callbacks, lsp_util.semantic_tokens)
  end
  -- }}}

  server_callbacks[name] = callbacks
  return callbacks
end

---The function to pass to the LSP's on_attach callback.
---@param client lspclient
---@param bufnr number
local function on_attach(client, bufnr) --{{{
  vim.api.nvim_buf_call(bufnr, function()
    local callbacks = capability_callbacks(client)
    for _, callback in ipairs(callbacks) do
      callback(client, bufnr)
    end

    lsp_util.setup_diagnostics(bufnr)
    lsp_util.support_commands()
  end)
end --}}}

return {
  on_attach = on_attach,
}

-- vim: fdm=marker fdl=0
