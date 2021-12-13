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

    local count = 0

    for _, client in pairs(active_clients) do
        severity = severity_lsp_to_vim(severity)
        local opts = { severity = severity }
        if client.id ~= nil then
            local namespace, ok = pcall(vim.diagnostic.get_namespace, client.id)
            if not ok then
                return 0
            end
            opts.namespace = namespace
        end
        count = count + #vim.diagnostic.get(0, opts)
    end

    return count
end

function M.diagnostics_exist(severity)
    return M.get_diagnostics_count(severity) > 0
end

function M.lsp_client_names()
    local clients = {}

    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
        clients[#clients+1] = client.name
    end

    return table.concat(clients, ' '),  ' '
end

-- Common function used by the diagnostics providers
local function diagnostics(severity)
    local count = M.get_diagnostics_count(severity)
    return count ~= 0 and tostring(count) or ''
end

function M.diagnostic_errors()
    return diagnostics('Error'), '  '
end

function M.diagnostic_warnings()
    return diagnostics('Warning'), '  '
end

function M.diagnostic_hints()
    return diagnostics('Hint'), '  '
end

function M.diagnostic_info()
    return diagnostics('Information'), '  '
end

return M
