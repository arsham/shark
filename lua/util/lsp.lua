local nvim = require('nvim')
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

---Executes go.mod tidy.
---@param filename string should be the full path of the go.mod file.
function M.go_mod_tidy(bufnr, filename)
    local clients = vim.lsp.get_active_clients(0)
    local command = {
        command = 'gopls.tidy',
        arguments = {{
            URIs = { 'file:/' .. filename },
        }},
    }
    for _, client in pairs(clients) do
        if client.name == 'gopls' then
            client.request('workspace/executeCommand', command, function(...)
                local result = vim.lsp.handlers['workspace/executeCommand'](...)
                vim.lsp.codelens.refresh()
                return result
            end, bufnr)
        end
    end
end

---Checks for dependency updates. It adds the found upgrades to the quickfix
---list.
---@param filename string should be the full path of the go.mod file.
function M.go_mod_check_upgrades(filename)
    local f = io.open(filename, 'r')
    local contents = f:read('*a')
    f:close()
    local modules = {}
    for line in contents:gmatch('[^\r\n]+') do
        local module = line:match('^%s+([%a\\/\\.-]+)%s+[^%s\\/]+')
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
        command = 'gopls.check_upgrades',
        arguments = {{
            URI = 'file:/' .. filename ,
            Modules = modules,
        }},
    }
    vim.lsp.buf.execute_command(command)
end

return M
