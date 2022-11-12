local lsp_util = require("settings.lsp.util")

---@alias lsp_client 'vim.lsp.client'

---The function to pass to the LSP's on_attach callback.
---@param client lsp_client
---@param bufnr number
-- stylua: ignore start
local function on_attach(client, bufnr) --{{{
  -- The first time some LSP servers are not attached currectly, therefore we
  -- force another read just once.
  if not vim.g._lsp_loaded_successfully then
    vim.g._lsp_loaded_successfully = true
    vim.api.nvim_exec_autocmds("BufRead", {})
    return
  end

  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  if
    buf_name:match("^%a+://")
    or buf_name:match(".+_LOCAL_.+")
    or buf_name:match(".+_REMOTE_.+")
    or buf_name:match(".+_BASE_.+")
    or buf_name:match("^/tmp/.+")
  then
    local old_notify = vim.notify
    vim.notify = function () end
    vim.lsp.buf_detach_client(bufnr, client.id)
    vim.diagnostic.disable(bufnr)
    vim.notify = old_notify
    return true
  end

  -- TODO: find out how to disable the statuline badges as well.
  if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
    vim.diagnostic.disable(bufnr)
    vim.defer_fn(function()
      vim.diagnostic.reset(nil, bufnr)
    end, 1000)
  end

  vim.api.nvim_buf_call(bufnr, function() --{{{
    -- Contains functions to be run before writing the buffer. The format
    -- function will format the while buffer, and the imports function will
    -- organise imports.
    local imports_hook = function() end
    local format_hook = function() end
    local caps = client.server_capabilities

    if caps.codeActionProvider then
      lsp_util.code_action()

      -- Either is it set to true, or there is a specified set of
      -- capabilities. Sumneko doesn't support it, but the
      -- client.supports_method returns true.
      local can_organise_imports = type(caps.codeActionProvider) == "table"
        and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
      if can_organise_imports then
        lsp_util.setup_organise_imports()
        imports_hook = lsp_util.lsp_organise_imports
      end
    end

    if caps.documentFormattingProvider then
      local disabled_servers = {
        "sumneko_lua",
        "jsonls",
        "sqls",
        "html",
      }
      lsp_util.document_formatting()
      format_hook = function()
        vim.lsp.buf.format({
          async = false,
          filter = function(server)
            return not vim.tbl_contains(disabled_servers, server.name)
          end,
        })
      end
    end
    if caps.documentRangeFormattingProvider then
      local disabled_servers = {
        "sumneko_lua",
        "jsonls",
        "html",
        "clangd",
      }
      lsp_util.document_range_formatting(disabled_servers)
    end

    local workspace_folder_supported = caps.workspace
      and caps.workspace.workspaceFolders
      and caps.workspace.workspaceFolders.supported
    if workspace_folder_supported           then lsp_util.workspace_folder_properties() end
    if caps.workspaceSymbolProvider         then lsp_util.workspace_symbol()            end
    if caps.hoverProvider                   then lsp_util.hover()                       end
    if caps.renameProvider                  then lsp_util.rename()                      end
    if caps.codeLensProvider                then lsp_util.code_lens()                   end
    if caps.definitionProvider              then lsp_util.goto_definition()             end
    if caps.referencesProvider              then lsp_util.find_references()             end
    if caps.declarationProvider             then lsp_util.declaration()                 end
    if caps.signatureHelpProvider           then lsp_util.signature_help()              end
    if caps.implementationProvider          then lsp_util.implementation()              end
    if caps.typeDefinitionProvider          then lsp_util.type_definition()             end
    if caps.documentSymbolProvider          then lsp_util.document_symbol()             end
    if caps.callHierarchyProvider           then lsp_util.call_hierarchy()              end
    if caps.completionProvider then
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    end
    if caps.definitionProvider then
      vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    lsp_util.setup_diagnostics(bufnr)
    lsp_util.setup_completions()
    lsp_util.support_commands()
    lsp_util.setup_events(client.name, imports_hook, format_hook)
    lsp_util.fix_null_ls_errors()
  end) --}}}
end --}}}
-- stylua: ignore end

local lsp_detach_group = vim.api.nvim_create_augroup("LSP_DETACH_GROUP", { clear = true })
vim.api.nvim_create_autocmd("LspDetach", {
  group = lsp_detach_group,
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].tagfunc = nil
    vim.bo[bufnr].omnifunc = nil
  end,
})

return {
  on_attach = on_attach,
}
