local M = {}

-- Adopted from the feline codebase.

---Returns true if a LSP server is attached to the current buffer.
---@return boolean
function M.is_lsp_attached()
    return next(vim.lsp.buf_get_clients(0)) ~= nil
end

---Returns true if at least one of the LSP servers has the given capability.
---@param capability string
---@return boolean
function M.has_lsp_capability(capability)
    local clients = vim.lsp.buf_get_clients(0)
    for _, client in pairs(clients) do
        local capabilities = client.resolved_capabilities
        if capabilities and capabilities[capability] then
            return true
        end
    end
    return false
end

---Turns the severity to a form vim.diagnostic.get accepts.
---@param severity string
---@return string
local function severity_lsp_to_vim(severity)
    if type(severity) == 'string' then
        severity = vim.lsp.protocol.DiagnosticSeverity[severity]
    end
    return severity
end

---Returns the diagnostic count for the current buffer.
---@param severity string
---@return number
function M.get_diagnostics_count(severity)
    local active_clients = vim.lsp.buf_get_clients(0)
    if not active_clients then return 0 end

    severity = severity_lsp_to_vim(severity)
    local opts = { severity = severity }
    return #vim.diagnostic.get(vim.api.nvim_get_current_buf(), opts)
end

---Returns true if there is a diagnostic with the given severity.
---@param severity string
---@return boolean
function M.diagnostics_exist(severity)
    return M.get_diagnostics_count(severity) > 0
end

-- Common function used by the diagnostics providers
local function diagnostics(severity)
    local count = M.get_diagnostics_count(severity)
    return count ~= 0 and tostring(count) or ''
end

---Returns the count of errors and a icon.
---@return string
---@return string
function M.diagnostic_errors()
    return diagnostics(vim.diagnostic.severity.ERROR), '  '
end

---Returns the count of warnings and a icon.
---@return string
---@return string
function M.diagnostic_warnings()
    return diagnostics(vim.diagnostic.severity.WARN), '  '
end

---Returns the count of hints and a icon.
---@return string
---@return string
function M.diagnostic_hints()
    return diagnostics(vim.diagnostic.severity.HINT), '  '
end

---Returns the count of informations and a icon.
---@return string
---@return string
function M.diagnostic_info()
    return diagnostics(vim.diagnostic.severity.INFO), '  '
end

return M
