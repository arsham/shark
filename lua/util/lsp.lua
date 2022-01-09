local nvim = require("nvim")
local M = {}

---Adopted from the feline codebase.

---Returns true if a LSP server is attached to the current buffer.
---@return boolean
function M.is_lsp_attached()
  return next(vim.lsp.buf_get_clients(0)) ~= nil
end

---Returns true if at least one of the LSP servers has the given capability.
---@param capability string
---@return boolean
function M.has_lsp_capability(capability) --{{{
  local clients = vim.lsp.buf_get_clients(0)
  for _, client in pairs(clients) do
    local capabilities = client.resolved_capabilities
    if capabilities and capabilities[capability] then
      return true
    end
  end
  return false
end --}}}

---Executes go.mod tidy.
---@param filename string should be the full path of the go.mod file.
function M.go_mod_tidy(bufnr, filename) --{{{
  local clients = vim.lsp.get_active_clients()
  local command = {
    command = "gopls.tidy",
    arguments = { {
      URIs = { "file:/" .. filename },
    } },
  }
  for _, client in pairs(clients) do
    if client.name == "gopls" then
      client.request("workspace/executeCommand", command, function(...)
        local result = vim.lsp.handlers["workspace/executeCommand"](...)
        --- if client.resolved_capabilities.codelens then
        if client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
        end
        return result
      end, bufnr)
    end
  end
end --}}}

---Checks for dependency updates. It adds the found upgrades to the quickfix
---list.
---@param filename string should be the full path of the go.mod file.
function M.go_mod_check_upgrades(filename) --{{{
  local f = io.open(filename, "r")
  local contents = f:read("*a")
  f:close()
  local modules = {}
  for line in contents:gmatch("[^\r\n]+") do
    local module = line:match("^%s+([%a\\/\\.-]+)%s+[^%s\\/]+")
    if module then
      table.insert(modules, module)
    end
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    for _, diag in pairs(result.diagnostics) do
      local cur_list = vim.fn.getqflist()
      local item = {
        filename = filename,
        lnum = diag.range.start.line + 1,
        col = diag.range.start.character + 1,
        text = diag.message,
      }
      table.insert(cur_list, item)
      vim.fn.setqflist(cur_list)
      nvim.ex.copen()
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.diagnostic.on_publish_diagnostics
  end

  local command = {
    command = "gopls.check_upgrades",
    arguments = { {
      URI = "file:/" .. filename,
      Modules = modules,
    } },
  }
  vim.lsp.buf.execute_command(command)
end --}}}

return M

-- vim: fdm=marker fdl=0
