local M = {}

-- Adopted from the feline codebase.

function M.is_lsp_attached()
    return next(vim.lsp.buf_get_clients(0)) ~= nil
end

local function severity_lsp_to_vim(severity)
    if type(severity) == 'string' then
        severity = vim.lsp.protocol.DiagnosticSeverity[severity]
    end
    return severity
end

function M.get_diagnostics_count(severity)
    local active_clients = vim.lsp.buf_get_clients(0)
    if not active_clients then return 0 end

    severity = severity_lsp_to_vim(severity)
    local opts = { severity = severity }
    return #vim.diagnostic.get(vim.api.nvim_get_current_buf(), opts)
end

function M.diagnostics_exist(severity)
    return M.get_diagnostics_count(severity) > 0
end

-- Common function used by the diagnostics providers
local function diagnostics(severity)
    local count = M.get_diagnostics_count(severity)
    return count ~= 0 and tostring(count) or ''
end

function M.diagnostic_errors()
    return diagnostics(vim.diagnostic.severity.ERROR), '  '
end

function M.diagnostic_warnings()
    return diagnostics(vim.diagnostic.severity.WARN), '  '
end

function M.diagnostic_hints()
    return diagnostics(vim.diagnostic.severity.HINT), '  '
end

function M.diagnostic_info()
    return diagnostics(vim.diagnostic.severity.INFO), '  '
end

return M
