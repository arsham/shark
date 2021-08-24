require('astronauta.keymap')
local nvim_command = vim.api.nvim_command
local util = require('util')

local M = {}

util.highlight("LspReferenceRead",  {ctermbg=180, guibg='#43464F', style='bold'})
util.highlight("LspReferenceText",  {ctermbg=180, guibg='#43464F', style='bold'})
util.highlight("LspReferenceWrite", {ctermbg=180, guibg='#43464F', style='bold'})

local signs = { Error = "🔥", Warning = "💩", Hint = "💡", Information = "💬" }
for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = 'SignColumn', numhl = "" })
end

local function restart_lsp()
    vim.cmd[[LspStop]]
    vim.defer_fn(function() vim.cmd[[LspStart]] end, 1000)
end
util.command{"RestartLsp", buffer=true, restart_lsp}
vim.keymap.nnoremap{'<leader>dr', restart_lsp, silent=true, buffer=true}

local function lsp_organise_imports()
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "table", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local timeout = 1000 -- ms

    local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
    if not resp then return end

    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if resp[client.id] then
            local result = resp[client.id].result
            if not result or not result[1] then return end

            local edit = result[1].edit
            vim.lsp.util.apply_workspace_edit(edit)
        end
    end
end

-- Returns the name of the struct, method or function.
local function get_current_node_name()
    local ts_utils = require'nvim-treesitter.ts_utils'
    local cur_node = ts_utils.get_node_at_cursor()
    local type_patterns = {
        method_declaration = 2,
        function_declaration= 1,
        type_spec = 0,
    }
    local stop = false
    local index = 1
    while cur_node do
        for rgx, k in pairs(type_patterns) do
            if cur_node:type() == rgx then
                stop = true
                index = k
                break
            end
        end
        if stop then break end
        cur_node = cur_node:parent()
    end

    if not cur_node then
        vim.notify("Test not found", vim.lsp.log_levels.WARN, {
            title = "User Command",
            timeout = 1000,
        })
        return ""
    end
    return (ts_utils.get_node_text(cur_node:child(index)))[1]
end

-- Attaches commands, mappings and autocmds to current buffer based on the
-- client's capabilities.
local function attach_mappings_commands(client)
    -- Contains functions to be run before writing the buffer. The format
    -- function will format the while buffer, and the imports function will
    -- organise imports.
    local pre_save = {
        format = function() end,
        imports = function() end,
    }
    local opts = {silent=true, buffer=true}
    local caps = client.resolved_capabilities
    if caps.code_action then
        nvim_command('command! -buffer -range CodeAction lua require("settings.lsp.util").code_action(<range> ~= 0, <line1>, <line2>)')
        vim.keymap.nnoremap{'<leader>ca', vim.lsp.buf.code_action, opts}

        -- Either is it set to true, or there is a specified set of
        -- capabilities.
        if caps.code_action == true or table.contains(caps.code_action.codeActionKinds, "source.organizeImports") then
            vim.keymap.nnoremap{'<leader>i', lsp_organise_imports, opts}
            pre_save.imports = lsp_organise_imports
        end
    end

    if caps.document_formatting then
        vim.keymap.nnoremap{"<leader>gq", vim.lsp.buf.formatting, opts}
        pre_save.format = function()
            vim.lsp.buf.formatting_sync(nil, 1000)
        end
    end

    util.augroup{"LSP_FORMAT_IMPORTS", {
        {"BufWritePre", buffer=true, docs="format and imports", run=function()
            pre_save.imports()
            pre_save.format()
        end},
    }}

    if caps.document_range_formatting then
        nvim_command('command! -buffer -range -bang Format lua require("settings.lsp.util").format_command(<range> ~= 0, <line1>, <line2>, "<bang>" == "!")')
        vim.keymap.vnoremap{"gq", ':Format<CR>', opts}
    end

    if caps.rename then
        util.command{'Rename', buffer=true, vim.lsp.buf.rename}
    end

    if caps.hover then
        vim.keymap.nnoremap{'H', vim.lsp.buf.hover, opts}
    end
    if caps.signature_help then
        vim.keymap.nnoremap{'K',     vim.lsp.buf.signature_help, opts}
        vim.keymap.inoremap{'<C-k>', vim.lsp.buf.signature_help, opts}
    end

    if caps.goto_definition then
        util.command{"Definition", buffer=true, vim.lsp.buf.definition}
        vim.keymap.nnoremap{'gd', vim.lsp.buf.definition, opts}
    end
    if caps.declaration then
        vim.keymap.nnoremap{'gD', vim.lsp.buf.declaration, opts}
    end
    if caps.type_definition then
        util.command{"TypeDefinition", buffer=true, vim.lsp.buf.type_definition}
    end
    if caps.implementation then
        util.command{"Implementation", buffer=true, vim.lsp.buf.implementation}
        vim.keymap.nnoremap{'<leader>gi', vim.lsp.buf.implementation, opts}
    end

    if caps.find_references then
        util.command{"References", buffer=true, vim.lsp.buf.references}
        vim.keymap.nnoremap{'gr', vim.lsp.buf.references, opts}
    end

    if caps.document_symbol then
        util.command{"DocumentSymbol", buffer=true, vim.lsp.buf.document_symbol}
        vim.keymap.nnoremap{'<leader>@', function()
            util.call_and_centre(vim.lsp.buf.document_symbol)
        end, opts}
    end
    if caps.workspace_symbol then
        util.command{"WorkspaceSymbols", buffer=true, vim.lsp.buf.workspace_symbol}
    end

    if caps.call_hierarchy then
        util.command{"Callees", buffer=true, vim.lsp.buf.outgoing_calls}
        util.command{"Callers", buffer=true, vim.lsp.buf.incoming_calls}
        vim.keymap.nnoremap{'<leader>gc', vim.lsp.buf.incoming_calls, opts}
    end

    util.command{"ListWorkspace", buffer=true, function()
        vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
            title = "Workspace Folders",
            timeout = 3000,
        })
    end}
    if caps.workspace_folder_properties.supported then
        nvim_command('command! -buffer -nargs=? -complete=dir AddWorkspace lua vim.lsp.buf.add_workspace_folder(<q-args> ~= "" and vim.fn.fnamemodify(<q-args>, ":p"))')
        nvim_command('command! -buffer -nargs=? -complete=customlist,v:lua.vim.lsp.buf.list_workspace_folders RemoveWorkspace lua vim.lsp.buf.remove_workspace_folder(<f-args>)')
    end

    util.command{"Log", buffer=true, "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()"}

    util.command{"Test", docs="locate tests for a node", buffer=true, function()
        local name = get_current_node_name()
        if name == "" then return nil end

        local pattern = "test" .. name
        vim.lsp.buf.workspace_symbol(pattern)
    end}

    vim.keymap.inoremap{'<Tab>',   require("completion").smart_tab,   opts}
    vim.keymap.inoremap{'<S-Tab>', require("completion").smart_s_tab, opts}
    vim.keymap.inoremap{'<c-j>',   require("completion").nextSource,  opts} -- "use <c-j> to switch to next completion
    vim.keymap.inoremap{'<c-k>',   require("completion").prevSource,  opts} -- "use <c-k> to switch to previous completion

    vim.keymap.nnoremap{'<leader>dd', vim.lsp.diagnostic.show_line_diagnostics, opts}
    vim.keymap.nnoremap{'<leader>dq', vim.lsp.diagnostic.set_qflist,            opts}
    vim.keymap.nnoremap{'<leader>dw', vim.lsp.diagnostic.set_loclist,           opts}
    vim.keymap.nnoremap{']d', function()
        util.call_and_centre(vim.lsp.diagnostic.goto_next)
    end, opts}
    vim.keymap.nnoremap{'[d', function()
        util.call_and_centre(vim.lsp.diagnostic.goto_prev)
    end, opts}
    util.command{"Diagnostics",       buffer=true, function() require('lspfuzzy').diagnostics(0) end}
    util.command{"DiagnosticsAll",    "LspDiagnosticsAll"}
end

function M.on_attach(client, bufnr)
    require('completion').on_attach()

    -- vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.bo.omnifunc = 'v:lua.omnifunc_sync'
    vim.api.nvim_buf_call(bufnr, function() attach_mappings_commands(client) end)

    util.augroup{"STOP_LSP_TYPES", {
        {events="BufReadPost,BufNewFile", targets="*/templates/*.yaml,*/templates/*.tpl", run="LspStop"},
    }}
end

function M.format_command(range_given, line1, line2, bang)
    if range_given then
        vim.lsp.buf.range_formatting(nil, {line1, 0}, {line2, 99999999})
    elseif bang then
        vim.lsp.buf.formatting_sync()
    else
        vim.lsp.buf.formatting()
    end
end

function M.code_action(range_given, line1, line2)
    if range_given then
        vim.lsp.buf.range_code_action(nil, {line1, 0}, {line2, 99999999})
    else
        vim.lsp.buf.code_action()
    end
end

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
--     { border = "single" }
-- )

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
--     { border = "single" }
-- )

-- TODO: is this any better?
local omnifunc_cache
function _G.omnifunc_sync(findstart, base)
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()

    if findstart == 1 then
        -- Cache state of cursor line and position due to the fact that it will
        -- change at the second call to this function (with `findstart = 0`). See:
        -- https://github.com/vim/vim/issues/8510.
        -- This is needed because request to LSP server is made on second call.
        -- If not done, server's completion mechanics will operate on different
        -- document and position.
        omnifunc_cache = {pos = pos, line = line}

        -- On first call return column of completion start
        local line_to_cursor = line:sub(1, pos[2])
        return vim.fn.match(line_to_cursor, '\\k*$')
    end

    -- Restore cursor line and position to the state of first call
    vim.api.nvim_set_current_line(omnifunc_cache.line)
    vim.api.nvim_win_set_cursor(0, omnifunc_cache.pos)

    -- Make request
    local bufnr  = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/completion', params, 2000)
    if not result then return {} end

    -- Transform request answer to list of completion matches
    local items = {}
    for _, item in pairs(result) do
        if not item.err then
            local matches = vim.lsp.util.text_document_completion_list_to_complete_items(item.result, base)
            vim.list_extend(items, matches)
        end
    end

    -- Restore back cursor line and position to the state of this call's start
    -- (avoids outcomes of Vim's internal line postprocessing)
    vim.api.nvim_set_current_line(line)
    vim.api.nvim_win_set_cursor(0, pos)

    return items
end

return M
