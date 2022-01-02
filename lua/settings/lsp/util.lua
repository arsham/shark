local nvim = require('nvim')
local util = require('util')

---Restats the LSP server. Fixes the problem with the LSP server not
---restarting with LspRestart command.
local function restart_lsp()
  nvim.ex.LspStop()
  vim.defer_fn(nvim.ex.LspStart, 1000)
end
util.buffer_command("RestartLsp", restart_lsp)
util.nnoremap{'<leader>dr', restart_lsp, silent=true, desc='Restart LSP server'}

local function lsp_organise_imports()
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "table", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local timeout = 1000 --- ms

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

---Returns the name of the struct, method or function.
---@return string
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

---Attaches commands, mappings and autocmds to current buffer based on the
---client's capabilities.
---@param client any
local function attach_mappings_commands(client)
  --- Contains functions to be run before writing the buffer. The format
  --- function will format the while buffer, and the imports function will
  --- organise imports.
  local pre_save = {
    format = function() end,
    imports = function() end,
  }
  local caps = client.resolved_capabilities
  if caps.code_action then
    util.buffer_command('CodeAction', function(args)
      require("settings.lsp.util").code_action(args.range ~= 0, args.line1, args.line2)
    end, {range=true})
    util.nnoremap{'<leader>ca', vim.lsp.buf.code_action, buffer=true, silent=true, desc='Code action'}
    util.vnoremap{'<leader>ca', ":'<,'>CodeAction<CR>", buffer=true, silent=true, desc='Code action'}

    --- Either is it set to true, or there is a specified set of
    --- capabilities.
    if type(caps.code_action) == "table" and _t(caps.code_action.codeActionKinds):contains("source.organizeImports") then
      util.nnoremap{'<leader>i', lsp_organise_imports, buffer=true, silent=true, desc='Organise imports'}
      pre_save.imports = lsp_organise_imports
    end
  end

  if caps.document_formatting then
    util.nnoremap{"<leader>gq", vim.lsp.buf.formatting, buffer=true, silent=true, desc='Format buffer'}
    pre_save.format = function()
      vim.lsp.buf.formatting_sync(nil, 2000)
    end
  end

  util.augroup{"LSP_FORMAT_IMPORTS", {
    {"BufWritePre", buffer=true, docs="format and imports", run=function()
      pre_save.imports()
      pre_save.format()
    end},
  }}

  if caps.document_range_formatting then
    util.buffer_command('Format', function(args)
      require("settings.lsp.util").format_command(args.range ~= 0, args.line1, args.line2, args.bang)
    end, {range=true})
    util.vnoremap{"gq", ':Format<CR>', buffer=true, silent=true, desc='Format range'}
    vim.bo.formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end

  if caps.rename then
    util.buffer_command('Rename', function() vim.lsp.buf.rename() end)
  end

  if caps.hover then
    util.nnoremap{'H',    vim.lsp.buf.hover,  buffer=true, silent=true, desc='show hover'}
    util.inoremap{'<C-h>', vim.lsp.buf.hover, buffer=true, silent=true, desc='show hover'}
  end
  if caps.signature_help then
    util.nnoremap{'K',    vim.lsp.buf.signature_help,  buffer=true, silent=true, desc='show signature help'}
    util.inoremap{'<C-l>', vim.lsp.buf.signature_help, buffer=true, silent=true, desc='show signature help'}
  end

  if caps.goto_definition then
    util.buffer_command("Definition", function() vim.lsp.buf.definition() end)
    util.nnoremap{'gd', vim.lsp.buf.definition, buffer=true, silent=true, desc='Go to definition'}
    vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
  end
  if caps.declaration then
    util.nnoremap{'gD', vim.lsp.buf.declaration, buffer=true, silent=true, desc='Go to declaration'}
  end
  if caps.type_definition then
    util.buffer_command("TypeDefinition", function() vim.lsp.buf.type_definition() end)
  end
  if caps.implementation then
    util.buffer_command("Implementation", function() vim.lsp.buf.implementation() end)
    util.nnoremap{'<leader>gi', vim.lsp.buf.implementation, buffer=true, silent=true, desc='Go to implementation'}
  end

  if caps.find_references then
    util.buffer_command("References", function() vim.lsp.buf.references() end)
    util.nnoremap{'gr', vim.lsp.buf.references, buffer=true, silent=true, desc='Go to references'}
  end

  if caps.document_symbol then
    util.buffer_command("DocumentSymbol", function() vim.lsp.buf.document_symbol() end)
    util.nnoremap{'<leader>@', function()
      vim.lsp.buf.document_symbol()
    end, buffer=true, silent=true}
  end
  if caps.workspace_symbol then
    util.buffer_command("WorkspaceSymbols", function() vim.lsp.buf.workspace_symbol() end)
  end

  if caps.call_hierarchy then
    util.buffer_command("Callees", function() vim.lsp.buf.outgoing_calls() end)
    util.buffer_command("Callers", function() vim.lsp.buf.incoming_calls() end)
    util.nnoremap{'<leader>gc', vim.lsp.buf.incoming_calls, buffer=true, silent=true, desc='show incoming calls'}
  end

  util.buffer_command("ListWorkspace", function()
    vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
      title = "Workspace Folders",
      timeout = 3000,
    })
  end)
  if caps.workspace_folder_properties.supported then
    util.buffer_command('AddWorkspace', function(args)
      vim.lsp.buf.add_workspace_folder(args.args and vim.fn.fnamemodify(args.args, ":p"))
      require("settings.lsp.util").format_command(args.range ~= 0, args.line1, args.line2, args.bang)
    end, {range=true, nargs='?', complete='dir'})
    util.buffer_command('RemoveWorkspace', function(args)
      vim.lsp.buf.remove_workspace_folder(args.args)
      require("settings.lsp.util").format_command(args.range ~= 0, args.line1, args.line2, args.bang)
    end, {range=true, nargs='?', complete='customlist,v:lua.vim.lsp.buf.list_workspace_folders'})
  end

  util.buffer_command("Log", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()")

  util.buffer_command("Test", function()
    local name = get_current_node_name()
    if name == "" then return nil end

    local pattern = "test" .. name
    vim.lsp.buf.workspace_symbol(pattern)
  end)

  util.inoremap{'<C-j>', '<C-n>', buffer=true, silent=true, desc='next completion items'}
  util.inoremap{'<C-k>', '<C-p>', buffer=true, silent=true, desc='previous completion items'}

  util.nnoremap{'<leader>dd', vim.diagnostic.open_float, buffer=true, silent=true, desc='show diagnostics'}
  util.nnoremap{'<leader>dq', vim.diagnostic.setqflist,  buffer=true, silent=true, desc='populate quickfix list with diagnostics'}
  util.nnoremap{'<leader>dw', vim.diagnostic.setloclist, buffer=true, silent=true, desc='populate local list with diagnostics'}
  util.nnoremap{']d', function()
    util.call_and_centre(vim.diagnostic.goto_next)
  end, buffer=true, silent=true, desc='goto next diagnostic'}
  util.nnoremap{'[d', function()
    util.call_and_centre(vim.diagnostic.goto_prev)
  end, buffer=true, silent=true, desc='goto previous diagnostic'}
  util.buffer_command("Diagnostics", function() require('lspfuzzy').diagnostics(0) end)
  util.buffer_command("DiagnosticsAll", "LspDiagnosticsAll")
end

local M = {}

---@alias lsp_client 'vim.lsp.client'

---The function to pass to the LSP's on_attach callback.
---@param client lsp_client
---@param bufnr number
function M.on_attach(client, bufnr)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  --- TODO: find out how to disable the statuline badges as well.
  if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
    vim.diagnostic.disable()
  end

  vim.api.nvim_buf_call(bufnr, function() attach_mappings_commands(client) end)

  util.augroup{"STOP_LSP_TYPES", {
    {events="BufReadPost,BufNewFile", targets="*/templates/*.yaml,*/templates/*.tpl", run="LspStop"},
  }}

  local caps = client.resolved_capabilities
  if caps.code_lens then
    util.buffer_command("CodeLensRefresh", function() vim.lsp.codelens.refresh() end)
    util.buffer_command("CodeLensRun", function() vim.lsp.codelens.run() end)
    util.nnoremap{'<leader>cr', vim.lsp.codelens.run, buffer=true, silent=true, desc='run code lenses'}

    util.augroup{"CODE_LENSES", {
      {"CursorHold,CursorHoldI,InsertLeave", buffer=true, run=function()
        vim.lsp.codelens.refresh()
      end},
    }}
  end
end

---Formats a range if given.
---@param range_given boolean
---@param line1 number
---@param line2 number
---@param bang boolean
function M.format_command(range_given, line1, line2, bang)
  if range_given then
    vim.lsp.buf.range_formatting(nil, {line1, 0}, {line2, 99999999})
  elseif bang then
    vim.lsp.buf.formatting_sync()
  else
    vim.lsp.buf.formatting()
  end
end

---Runs code actions on a given range.
---@param range_given boolean
---@param line1 number
---@param line2 number
function M.code_action(range_given, line1, line2)
  if range_given then
    vim.lsp.buf.range_code_action(nil, {line1, 0}, {line2, 99999999})
  else
    vim.lsp.buf.code_action()
  end
end

return M
