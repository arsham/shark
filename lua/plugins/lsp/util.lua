local M = {}

---@type Quick
local quick = require("arshlib.quick")
local lsp = require("arshlib.lsp")
local fzf = require("fzf-lua")
local diagnostics = require("fzf-lua.providers.diagnostic")
local util = require("util")

function M.lsp_organise_imports() --{{{
  local context = { source = { organizeImports = true } }
  vim.validate({ context = { context, "table", true } })

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local method = "textDocument/codeAction"
  local timeout = 1000 -- ms

  local ok, resp = pcall(vim.lsp.buf_request_sync, 0, method, params, timeout)
  if not ok or not resp then
    return
  end

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    local offset_encoding = client.offset_encoding or "utf-16"
    if client.id and resp[client.id] then
      local result = resp[client.id].result
      if result and result[1] and result[1].edit then
        local edit = result[1].edit
        if edit then
          vim.lsp.util.apply_workspace_edit(result[1].edit, offset_encoding)
        end
      end
    end
  end
end --}}}

---Returns the name of the struct, method or function.
---@return string
local function get_current_node_name() --{{{
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
  return (vim.treesitter.query.get_node_text(cur_node:child(index)))[1]
end --}}}

---Formats a range if given.
---@param disabled_servers table
---@param range_given boolean
---@param line1 number
---@param line2 number
---@param bang boolean
local function format_command(disabled_servers, range_given, line1, line2, bang) --{{{
  if range_given then
    vim.lsp.buf.format({
      range = {
        start = { line1, 0 },
        ["end"] = { line2, 99999999 },
      },
      filter = function(server)
        return not vim.tbl_contains(disabled_servers, server.name)
      end,
    })
  elseif bang then
    vim.lsp.buf.format({
      async = false,
      filter = function(server)
        return not vim.tbl_contains(disabled_servers, server.name)
      end,
    })
  else
    vim.lsp.buf.format({
      async = true,
      filter = function(server)
        return not vim.tbl_contains(disabled_servers, server.name)
      end,
    })
  end
end --}}}

---Runs code actions on a given range.
---@param range_given boolean
---@param line1 number
---@param line2 number
local function code_action(range_given, line1, line2) --{{{
  if range_given then
    vim.lsp.buf.code_action({
      range = {
        start = { line1, 0 },
        ["end"] = { line2, 99999999 },
      },
    })
  else
    vim.lsp.buf.code_action()
  end
end --}}}

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function xnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("x", key, fn, opts)
end --}}}
local function inoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("i", key, fn, opts)
end --}}}

function M.code_action() --{{{
  quick.buffer_command("CodeAction", function(args)
    code_action(args.range ~= 0, args.line1, args.line2)
  end, { range = true })
  nnoremap("<localleader>ca", code_action, "Code action")
  xnoremap("<localleader>ca", ":'<,'>CodeAction<CR>", "Code action")
end --}}}

function M.setup_organise_imports() --{{{
  nnoremap("<localleader>i", M.lsp_organise_imports, "Organise imports")
end --}}}

function M.document_formatting() --{{{
  nnoremap("<localleader>gq", vim.lsp.buf.format, "Format buffer")
end --}}}

local function document_range_formatting(disabled_servers, args) --{{{
  format_command(disabled_servers, args.range ~= 0, args.line1, args.line2, args.bang)
end --}}}

-- selene: allow(global_usage)
local function format_range_operator(disabled_servers) --{{{
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")
    finish[2] = 99999999
    vim.lsp.buf.format({
      range = {
        start = start,
        ["end"] = finish,
      },
      async = false,
      filter = function(server)
        return not vim.tbl_contains(disabled_servers, server.name)
      end,
    })
    vim.go.operatorfunc = old_func
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end --}}}

function M.document_range_formatting(disabled_servers) --{{{
  quick.buffer_command("Format", function(args)
    document_range_formatting(disabled_servers, args)
  end, { range = true })
  xnoremap("gq", function(args)
    local line1, _ = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local line2, _ = unpack(vim.api.nvim_buf_get_mark(0, "]"))
    if line1 > line2 then
      line1, line2 = line2, line1
    end
    document_range_formatting(disabled_servers, { range = 1, line1 = line1, line2 = line2 })
  end, "Format range")
  nnoremap("gq", function()
    format_range_operator(disabled_servers)
  end, "Format range")

  vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:3000})"
end --}}}

function M.rename() --{{{
  vim.keymap.set("n", "<localleader>rn", function()
    return ":Rename " .. vim.fn.expand("<cword>")
  end, { expr = true })
end --}}}

function M.hover() --{{{
  nnoremap("H", vim.lsp.buf.hover, "show hover")
  inoremap("<M-h>", vim.lsp.buf.hover, "show hover")
end --}}}

function M.signature_help() --{{{
  nnoremap("K", vim.lsp.buf.signature_help, "show signature help")
  inoremap("<M-l>", vim.lsp.buf.signature_help, "show signature help")
end --}}}

function M.goto_definition() --{{{
  local perform = function()
    fzf.lsp_definitions({ jump_to_single_result = true })
  end
  quick.buffer_command("Definition", perform)
  nnoremap("gd", perform, "Go to definition")
  vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
end --}}}

function M.declaration() --{{{
  nnoremap("gD", function()
    fzf.lsp_declarations({ jump_to_single_result = true })
  end, "Go to declaration")
end --}}}

function M.type_definition() --{{{
  quick.buffer_command("TypeDefinition", function()
    fzf.lsp_typedefs({ jump_to_single_result = true })
  end)
end --}}}

function M.implementation() --{{{
  local perform = function()
    fzf.lsp_implementations({ jump_to_single_result = true })
  end
  quick.buffer_command("Implementation", perform)
  nnoremap("<localleader>gi", perform, "Go to implementation")
end --}}}

function M.find_references() --{{{
  local perform = function()
    fzf.lsp_references({ jump_to_single_result = true })
  end
  quick.buffer_command("References", perform)
  nnoremap("gr", perform, "Go to references")
end --}}}

function M.document_symbol() --{{{
  local perform = function()
    fzf.lsp_document_symbols({
      jump_to_single_result = true,
      fzf_opts = {
        ["--with-nth"] = "2..",
      },
    })
  end
  quick.buffer_command("DocumentSymbol", perform)
  nnoremap("<localleader>@", perform, "Document symbol")
end --}}}

function M.workspace_symbol() --{{{
  quick.buffer_command("WorkspaceSymbols", fzf.lsp_live_workspace_symbols)
end --}}}

function M.call_hierarchy() --{{{
  quick.buffer_command("Callers", fzf.lsp_incoming_calls)
  nnoremap("<localleader>gc", fzf.lsp_incoming_calls, "show incoming calls")
  quick.buffer_command("Callees", fzf.lsp_outgoing_calls)
end --}}}

quick.buffer_command("ListWorkspace", function() --{{{
  vim.notify(vim.lsp.buf.list_workspace_folders() or {}, vim.lsp.log_levels.INFO, {
    title = "Workspace Folders",
    timeout = 3000,
  })
end) --}}}

function M.workspace_folder_properties() --{{{
  local function add_workspace(args)
    vim.lsp.buf.add_workspace_folder(args.args and vim.fn.fnamemodify(args.args, ":p"))
  end
  quick.buffer_command(
    "AddWorkspace",
    add_workspace,
    { range = true, nargs = "?", complete = "dir" }
  )
  quick.buffer_command(
    "RemoveWorkspace",
    function(args)
      vim.lsp.buf.remove_workspace_folder(args.args)
    end,
    { range = true, nargs = "?", complete = "customlist,v:lua.vim.lsp.buf.list_workspace_folders" }
  )
end --}}}

local code_lenses_group = vim.api.nvim_create_augroup("CODE_LENSES", { clear = true })
function M.code_lens() --{{{
  if util.buffer_has_var("code_lens") then
    return
  end
  quick.buffer_command("CodeLensRefresh", vim.lsp.codelens.refresh)
  quick.buffer_command("CodeLensRun", vim.lsp.codelens.run)
  nnoremap("<localleader>cr", vim.lsp.codelens.run, "run code lenses")

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
    group = code_lenses_group,
    callback = vim.lsp.codelens.refresh,
    buffer = 0,
  })
end --}}}

function M.setup_completions() --{{{
  inoremap("<C-j>", "<C-n>", "next completion items")
  inoremap("<C-k>", "<C-p>", "previous completion items")
end --}}}

local lsp_events_group = vim.api.nvim_create_augroup("LSP_EVENTS", { clear = true })

function M.setup_events(client, imports, format) --{{{
  if not util.buffer_has_var("lsp_formatting_imports_" .. client) then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_events_group,
      buffer = 0,
      callback = function()
        imports()
        format()
      end,
      desc = "format and imports",
    })
  end
end --}}}
-- stylua: ignore end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = lsp_events_group,
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl" },
  command = "silent LspStop",
  desc = "disable lsp on helm charts",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = lsp_events_group,
  pattern = "go.mod",
  callback = function()
    vim.opt_local.formatoptions:remove({ "t" })
  end,
  once = true,
  desc = "don't wrap me",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_events_group,
  pattern = "go.mod",
  callback = function(args)
    local filename = vim.fn.expand("%:p")
    lsp.go_mod_tidy(tonumber(args.buf), filename)
  end,
  desc = "run go mod tidy on save",
})

function M.fix_null_ls_errors() --{{{
  local default_exe_handler = vim.lsp.handlers["workspace/executeCommand"]
  vim.lsp.handlers["workspace/executeCommand"] = function(err, ...)
    -- supress NULL_LS error msg
    local prefix = "NULL_LS"
    if err and err.message:sub(1, #prefix) == prefix then
      return
    end
    return default_exe_handler(err, ...)
  end
end --}}}

function M.support_commands() --{{{
  quick.buffer_command("ListWorkspace", function()
    vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
      title = "Workspace Folders",
      timeout = 3000,
    })
  end)
  quick.buffer_command("Log", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()")

  quick.buffer_command("Test", function()
    local name = get_current_node_name()
    if name == "" then
      return nil
    end

    local pattern = "test" .. name
    vim.lsp.buf.workspace_symbol(pattern)
  end)

  ---Restats the LSP server. Fixes the problem with the LSP server not
  -- restarting with LspRestart command.
  local function restart_lsp()
    vim.cmd.LspStop()
    vim.defer_fn(function()
      vim.cmd.LspStart()
    end, 1000)
  end
  quick.buffer_command("RestartLsp", restart_lsp)
  nnoremap("<localleader>dr", restart_lsp, "Restart LSP server")
end --}}}

local diagnostic_ns = vim.api.nvim_create_namespace("diagnostics")
local function show_diagnostics()
  vim.schedule(function()
    if vim.diagnostic.config().virtual_lines then
      -- If the lsp_lines is activated we bail, otherwise we get duplicates.
      return
    end
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local bufnr = vim.api.nvim_get_current_buf()
    local dg = vim.diagnostic.get(bufnr, { lnum = line })
    vim.diagnostic.show(diagnostic_ns, bufnr, dg, {
      virtual_text = {
        source = true,
      },
    })
  end)
end

local diagnostics_group = vim.api.nvim_create_augroup("LSP_DIAGNOSTICS_GROUP", { clear = true })
function M.setup_diagnostics(bufnr) --{{{
  nnoremap("<localleader>dd", vim.diagnostic.open_float, "show diagnostics")
  nnoremap("<localleader>dq", vim.diagnostic.setqflist, "populate quickfix")
  nnoremap("<localleader>dw", vim.diagnostic.setloclist, "populate local list")

  nnoremap("]d", function()
    quick.call_and_centre(vim.diagnostic.goto_next)
  end, "goto next diagnostic")
  nnoremap("[d", function()
    quick.call_and_centre(vim.diagnostic.goto_prev)
  end, "goto previous diagnostic")

  quick.buffer_command("Diagnostics", function()
    diagnostics.diagnostics({})
  end)
  quick.buffer_command("DiagnosticsAll", function()
    diagnostics.all({})
  end)
  quick.buffer_command("DiagnosticsDisable", function()
    vim.diagnostic.disable(bufnr)
  end)
  quick.buffer_command("DiagnosticsEnable", function()
    vim.diagnostic.enable(bufnr)
  end)

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = diagnostics_group,
    buffer = bufnr,
    callback = show_diagnostics,
  })
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = diagnostics_group,
    buffer = bufnr,
    callback = show_diagnostics,
  })
end --}}}

function M.setup_semantic_tokens(bufnr) -- {{{
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.buf.semantic_tokens_full,
  })
end -- }}}

local handler = function(err)
  if err then
    local msg = string.format("Error reloading Rust workspace: %v", err)
    ---@diagnostic disable-next-line: redundant-parameter
    vim.notify(msg, vim.lsp.log_levels.ERROR, {
      title = "Reloading Rust workspace",
      timeout = 3000,
    })
  else
    vim.notify("Workspace has been reloaded")
  end
end

local function reload_rust_workspace()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "rust_analyzer" then
      client.request("rust-analyzer/reloadWorkspace", nil, handler, 0)
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.rs",
  callback = function()
    quick.buffer_command("ReloadWorkspace", function()
      vim.lsp.buf_request(0, "rust-analyzer/reloadWorkspace", nil, handler)
    end, { range = true })
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("LSP_RUST_GROUP", { clear = true }),
  pattern = "*/Cargo.toml",
  callback = reload_rust_workspace,
})

return M

-- vim: fdm=marker fdl=0
