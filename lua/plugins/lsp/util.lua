---@diagnostic disable: duplicate-set-field, param-type-mismatch
local M = {}

local quick = require("arshlib.quick")
local fzf = require("fzf-lua")
local util = require("config.util")
local augroup = require("config.util").augroup

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function xnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("x", key, fn, opts)
end --}}}

local diagnostics_group = vim.api.nvim_create_augroup("LspDiagnosticsGroup", { clear = true })

function M.setup_diagnostics(bufnr) --{{{
  nnoremap("<localleader>dd", vim.diagnostic.open_float, "show diagnostics")
  nnoremap("<localleader>dq", vim.diagnostic.setqflist, "populate quickfix")
  nnoremap("<localleader>dw", vim.diagnostic.setloclist, "populate local list")

  -- stylua: ignore start
  local next = vim.diagnostic.goto_next
  local prev = vim.diagnostic.goto_prev
  local repeat_ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
  if repeat_ok then
    next, prev= ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
  end

  nnoremap("]d", function() quick.call_and_centre(next) end, "goto next diagnostic")
  nnoremap("[d", function() quick.call_and_centre(prev) end, "goto previous diagnostic")

  quick.buffer_command("DiagLoc", function() vim.diagnostic.setloclist() end)
  quick.buffer_command("DiagQf",  function() vim.diagnostic.setqflist()  end)

  local ok, diagnostics = pcall(require, "fzf-lua.providers.diagnostic")
  if ok then
    quick.buffer_command("Diagnostics",    function() diagnostics.diagnostics({}) end)
    quick.buffer_command("Diag",           function() diagnostics.diagnostics({}) end)
    quick.buffer_command("DiagnosticsAll", function() diagnostics.all({})         end)
    quick.buffer_command("DiagAll",        function() diagnostics.all({})         end)
  end
  -- stylua: ignore end
  quick.buffer_command("DiagnosticsDisable", function()
    vim.diagnostic.enable(false, { bufnr = bufnr })
  end)
  quick.buffer_command("DiagnosticsEnable", function()
    vim.diagnostic.enable(true, { bufnr = bufnr })
  end)

  -- Populate loclist with the current buffer diagnostics.
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = diagnostics_group,
    buffer = bufnr,
    callback = function()
      vim.diagnostic.setloclist({ open = false })
    end,
  })
end --}}}

local get_clients = (
  vim.lsp.get_clients ~= nil and vim.lsp.get_clients -- nvim 0.10+
  or vim.lsp.get_active_clients
)

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

  for _, client in ipairs(get_clients()) do
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
  xnoremap("gq", function()
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

local lsp_formatting_imports = augroup("lsp_formatting_imports")
---Setup events for formatting and imports.
---@param client lspclient
---@param imports function
---@param format function
---@param bufnr number?
function M.setup_events(client, imports, format, bufnr) --{{{
  if not util.buffer_has_var("lsp_formatting_imports_" .. client.name) then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_formatting_imports,
      buffer = bufnr or 0,
      callback = function()
        imports()
        format()
      end,
      desc = "format and imports",
    })
  end
end --}}}

function M.workspace_folder_properties() --{{{
  quick.buffer_command("WorkspaceList", function()
    vim.notify(vim.lsp.buf.list_workspace_folders() or {}, vim.lsp.log_levels.INFO, {
      title = "Workspace Folders",
      timeout = 3000,
    })
  end)

  quick.buffer_command("WorkspaceAdd", function(args)
    vim.lsp.buf.add_workspace_folder(args.args and vim.fn.fnamemodify(args.args, ":p"))
  end, { range = true, nargs = "?", complete = "dir" })

  quick.buffer_command(
    "WorkspaceRemove",
    function(args)
      vim.lsp.buf.remove_workspace_folder(args.args)
    end,
    { range = true, nargs = "?", complete = "customlist,v:lua.vim.lsp.buf.list_workspace_folders" }
  )
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

function M.code_action() --{{{
  quick.buffer_command("CodeAction", function(args)
    code_action(args.range ~= 0, args.line1, args.line2)
  end, { range = true })
  nnoremap("<localleader>ca", code_action, "Code action")
  xnoremap("<localleader>ca", ":'<,'>CodeAction<CR>", "Code action")
end --}}}


function M.support_commands() --{{{
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

  quick.buffer_command("ListWorkspace", function()
    vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
      title = "Workspace Folders",
      timeout = 3000,
    })
  end)
end --}}}

local handler = function(err)
  if err then
    local msg = string.format("Error reloading Rust workspace: %v", err)
    vim.notify(msg, vim.lsp.log_levels.ERROR, {
      title = "Reloading Rust workspace",
      timeout = 3000,
    })
  else
    vim.notify("Workspace has been reloaded")
  end
end

local function reload_rust_workspace()
  for _, client in ipairs(get_clients()) do
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
  group = augroup("reload_rust_workspace"),
  pattern = "*/Cargo.toml",
  callback = reload_rust_workspace,
})


return M

-- vim: fdm=marker fdl=0
