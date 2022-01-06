local M = {}

local nvim = require("nvim")
local util = require("util")

function M.lsp_organise_imports()
  local context = { source = { organizeImports = true } }
  vim.validate({ context = { context, "table", true } })

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local timeout = 1000 --- ms

  local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
  if not resp then
    return
  end

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.id and resp[client.id] then
      local result = resp[client.id].result
      if result and result[1] and result[1].edit then
        local edit = result[1].edit
        if edit then
          vim.lsp.util.apply_workspace_edit(result[1].edit)
        end
      end
    end
  end
end

---Returns the name of the struct, method or function.
---@return string
local function get_current_node_name()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local cur_node = ts_utils.get_node_at_cursor()
  local type_patterns = {
    method_declaration = 2,
    function_declaration = 1,
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
    if stop then
      break
    end
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

---Formats a range if given.
---@param range_given boolean
---@param line1 number
---@param line2 number
---@param bang boolean
local function format_command(range_given, line1, line2, bang)
  if range_given then
    vim.lsp.buf.range_formatting(nil, { line1, 0 }, { line2, 99999999 })
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
local function code_action(range_given, line1, line2)
  if range_given then
    vim.lsp.buf.range_code_action(nil, { line1, 0 }, { line2, 99999999 })
  else
    vim.lsp.buf.code_action()
  end
end

local function nnoremap(key, fn, desc, ...)
  vim.keymap.set("n", key, fn, { noremap = true, buffer = true, silent = true, desc = desc, ... })
end
local function vnoremap(key, fn, desc, ...)
  vim.keymap.set("v", key, fn, { noremap = true, buffer = true, silent = true, desc = desc, ... })
end
local function inoremap(key, fn, desc, ...)
  vim.keymap.set("i", key, fn, { noremap = true, buffer = true, silent = true, desc = desc, ... })
end

function M.code_action()
  util.buffer_command("CodeAction", function(args)
    code_action(args.range ~= 0, args.line1, args.line2)
  end, { range = true })
  nnoremap("<leader>ca", vim.lsp.buf.code_action, "Code action")
  vnoremap("<leader>ca", ":'<,'>CodeAction<CR>", "Code action")
end

function M.setup_organise_imports()
  nnoremap("<leader>i", M.lsp_organise_imports, "Organise imports")
end

function M.document_formatting()
  nnoremap("<leader>gq", vim.lsp.buf.formatting, "Format buffer")
end

local function document_range_formatting(args)
  format_command(args.range ~= 0, args.line1, args.line2, args.bang)
end
function M.document_range_formatting()
  util.buffer_command("Format", document_range_formatting, { range = true })
  vnoremap("gq", document_range_formatting, "Format range")
  vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
end

local function rename_symbol(args)
  if args.args == "" then
    vim.lsp.buf.rename()
  else
    vim.lsp.buf.rename(args.args)
  end
end
function M.rename()
  util.buffer_command("Rename", rename_symbol, { nargs = "?" })
end

function M.hover()
  nnoremap("H", vim.lsp.buf.hover, "show hover")
  inoremap("<C-h>", vim.lsp.buf.hover, "show hover")
end

function M.signature_help()
  nnoremap("K", vim.lsp.buf.signature_help, "show signature help")
  inoremap("<C-l>", vim.lsp.buf.signature_help, "show signature help")
end

function M.goto_definition()
  util.buffer_command("Definition", vim.lsp.buf.definition)
  nnoremap("gd", vim.lsp.buf.definition, "Go to definition")
  vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
end

function M.declaration()
  nnoremap("gD", vim.lsp.buf.declaration, "Go to declaration")
end

function M.type_definition()
  util.buffer_command("TypeDefinition", vim.lsp.buf.type_definition)
end

function M.implementation()
  util.buffer_command("Implementation", vim.lsp.buf.implementation)
  nnoremap("<leader>gi", vim.lsp.buf.implementation, "Go to implementation")
end

function M.find_references()
  util.buffer_command("References", vim.lsp.buf.references)
  nnoremap("gr", vim.lsp.buf.references, "Go to references")
end

function M.document_symbol()
  util.buffer_command("DocumentSymbol", vim.lsp.buf.document_symbol)
  nnoremap("<leader>@", vim.lsp.buf.document_symbol, "Document symbol")
end

function M.workspace_symbol()
  util.buffer_command("WorkspaceSymbols", vim.lsp.buf.workspace_symbol)
end

function M.call_hierarchy()
  util.buffer_command("Callees", vim.lsp.buf.outgoing_calls)
  util.buffer_command("Callers", vim.lsp.buf.incoming_calls)
  nnoremap("<leader>gc", vim.lsp.buf.incoming_calls, "show incoming calls")
end

util.buffer_command("ListWorkspace", function()
  vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
    title = "Workspace Folders",
    timeout = 3000,
  })
end)

function M.workspace_folder_properties()
  local function add_workspace(args)
    vim.lsp.buf.add_workspace_folder(args.args and vim.fn.fnamemodify(args.args, ":p"))
  end
  util.buffer_command(
    "AddWorkspace",
    add_workspace,
    { range = true, nargs = "?", complete = "dir" }
  )
  util.buffer_command(
    "RemoveWorkspace",
    function(args)
      vim.lsp.buf.remove_workspace_folder(args.args)
    end,
    { range = true, nargs = "?", complete = "customlist,v:lua.vim.lsp.buf.list_workspace_folders" }
  )
end

util.augroup({ "CODE_LENSES" })
function M.code_lens()
  util.buffer_command("CodeLensRefresh", vim.lsp.codelens.refresh)
  util.buffer_command("CodeLensRun", vim.lsp.codelens.run)
  nnoremap("<leader>cr", vim.lsp.codelens.run, "run code lenses")

  util.autocmd({
    "CursorHold,CursorHoldI,InsertLeave",
    group = "CODE_LENSES",
    run = vim.lsp.codelens.refresh,
    buffer = true,
  })
end

function M.setup_completions()
  inoremap("<C-j>", "<C-n>", "next completion items")
  inoremap("<C-k>", "<C-p>", "previous completion items")
end

util.augroup({ "LSP_EVENTS" })
function M.setup_events(imports, format)
  util.autocmd({
    "BufWritePre",
    group = "LSP_EVENTS",
    buffer = true,
    docs = "format and imports",
    run = function()
      imports()
      format()
    end,
  })

  util.autocmd({
    "BufReadPost,BufNewFile",
    "*/templates/*.yaml,*/templates/*.tpl",
    run = "LspStop",
    group = "LSP_EVENTS",
  })

  util.autocmd({
    "InsertEnter",
    "go.mod",
    run = function()
      vim.bo.formatoptions = vim.bo.formatoptions:gsub("t", "")
    end,
    group = "LSP_EVENTS",
    once = true,
    docs = "don't wrap me",
  })

  util.autocmd({
    "BufWritePre",
    "go.mod",
    run = function()
      local filename = vim.fn.expand("%:p")
      local bufnr = vim.fn.expand("<abuf>")
      require("util.lsp").go_mod_tidy(tonumber(bufnr), filename)
    end,
    group = "LSP_EVENTS",
    docs = "run go mod tidy on save",
  })

  local function go_mod_check()
    local filename = vim.fn.expand("<amatch>")
    require("util.lsp").go_mod_check_upgrades(filename)
  end
  util.autocmd({
    "BufRead",
    "go.mod",
    run = go_mod_check,
    group = "LSP_EVENTS",
    docs = "check for updates",
  })
end

function M.fix_null_ls_errors()
  local default_exe_handler = vim.lsp.handlers["workspace/executeCommand"]
  vim.lsp.handlers["workspace/executeCommand"] = function(err, ...)
    -- supress NULL_LS error msg
    local prefix = "NULL_LS"
    if err and err.message:sub(1, #prefix) == prefix then
      return
    end
    return default_exe_handler(err, ...)
  end
end

function M.support_commands()
  util.buffer_command("ListWorkspace", function()
    vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
      title = "Workspace Folders",
      timeout = 3000,
    })
  end)
  util.buffer_command("Log", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()")

  util.buffer_command("Test", function()
    local name = get_current_node_name()
    if name == "" then
      return nil
    end

    local pattern = "test" .. name
    vim.lsp.buf.workspace_symbol(pattern)
  end)

  ---Restats the LSP server. Fixes the problem with the LSP server not
  ---restarting with LspRestart command.
  local function restart_lsp()
    nvim.ex.LspStop()
    vim.defer_fn(nvim.ex.LspStart, 1000)
  end
  util.buffer_command("RestartLsp", restart_lsp)
  nnoremap("<leader>dr", restart_lsp, "Restart LSP server")
end

function M.setup_diagnostics()
  nnoremap("<leader>dd", vim.diagnostic.open_float, "show diagnostics")
  nnoremap("<leader>dq", vim.diagnostic.setqflist, "populate quickfix")
  nnoremap("<leader>dw", vim.diagnostic.setloclist, "populate local list")

  nnoremap("]d", function()
    util.call_and_centre(vim.diagnostic.goto_next)
  end, "goto next diagnostic")
  nnoremap("[d", function()
    util.call_and_centre(vim.diagnostic.goto_prev)
  end, "goto previous diagnostic")

  util.buffer_command("Diagnostics", function()
    require("lspfuzzy").diagnostics(0)
  end)
  util.buffer_command("DiagnosticsAll", "LspDiagnosticsAll")
end

return M
