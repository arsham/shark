local lsp_util = require("plugins.lsp.util")
local quick = require("arshlib.quick")
local fzf = require("fzf-lua")
local util = require("config.util")

local server_callbacks = {}

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function inoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("i", key, fn, opts)
end --}}}
local function xnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("x", key, fn, opts)
end --}}}

-- Go to reference {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/references") then
      local perform = function()
        fzf.lsp_references({ jump_to_single_result = true })
      end
      quick.buffer_command("References", perform)
      nnoremap("grr", perform, "Go to references")
    end
  end,
}) -- }}}

-- Completion {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/completion") then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
  end,
}) -- }}}

-- Hover {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/hover") then
      nnoremap("H", vim.lsp.buf.hover, "Show hover")
      inoremap("<M-h>", vim.lsp.buf.hover, "Show hover")
    end
  end,
}) -- }}}

-- Go to definition {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/definition") then
      local perform = function()
        fzf.lsp_definitions({ jump_to_single_result = true })
      end
      quick.buffer_command("Definition", perform)
      nnoremap("gd", perform, "Go to definition")
      vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
    end
  end,
}) -- }}}

-- Signature help {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/signatureHelp") then
      nnoremap("K", vim.lsp.buf.signature_help, "show signature help")
      inoremap("<M-l>", vim.lsp.buf.signature_help, "show signature help")
    end
  end,
}) -- }}}

-- Workspace symbol {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("workspace/symbol") then
      quick.buffer_command("WorkspaceSymbols", fzf.lsp_live_workspace_symbols)
    end
  end,
}) -- }}}

-- Document symbol {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/documentSymbol") then
      local perform = function()
        fzf.lsp_document_symbols({
          jump_to_single_result = true,
        })
      end
      quick.buffer_command("DocumentSymbol", perform)
      nnoremap("<localleader>@", perform, "Document symbol")
    end
  end,
}) -- }}}

-- Rename {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/rename") then
      vim.keymap.set("n", "grn", function()
        return ":Rename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end
  end,
}) -- }}}

-- Implementation {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/implementation") then
      local perform = function()
        local check = "_mock.go"
        local filter = function(items)
          local ret = {}
          for _, item in ipairs(items) do
            if item.filename:sub(-#check) ~= check then
              table.insert(ret, item)
            end
          end
          return ret
        end
        fzf.lsp_implementations({
          jump_to_single_result = true,
          filter = filter,
        })
      end
      quick.buffer_command("Implementation", perform)
      nnoremap("<localleader>gi", perform, "Go to implementation")
    end
  end,
}) -- }}}

-- Type definition {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/typeDefinition") then
      quick.buffer_command("TypeDefinition", function()
        fzf.lsp_typedefs({ jump_to_single_result = true })
      end)
    end
  end,
}) -- }}}

-- Declaration {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/declaration") then
      nnoremap("gD", function()
        fzf.lsp_declarations({ jump_to_single_result = true })
      end, "Go to declaration")
    end
  end,
}) -- }}}

-- Code lenses {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if
      client.supports_method("textDocument/codeLens") or client.supports_method("codeLens/resolve")
    then
      if util.buffer_has_var("code_lens") then
        return
      end
      quick.buffer_command("CodeLensRefresh", vim.lsp.codelens.refresh)
      quick.buffer_command("CodeLensRun", vim.lsp.codelens.run)
      nnoremap("<localleader>cr", vim.lsp.codelens.run, "run code lenses")
    end
  end,
}) -- }}}

-- Call hierarchy {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if
      client.supports_method("textDocument/prepareCallHierarchy")
      or client.supports_method("callHierarchy/incomingCalls")
      or client.supports_method("callHierarchy/outgoingCalls")
    then
      quick.buffer_command("Callers", fzf.lsp_incoming_calls)
      nnoremap("<localleader>gc", fzf.lsp_incoming_calls, "show incoming calls")
      quick.buffer_command("Callees", fzf.lsp_outgoing_calls)
    end
  end,
}) -- }}}

-- Semantic tokens {{{

---@param method string
---@return vim.lsp.Client[]
local function get_clients(method)
  if vim.fn.has("nvim-0.10") == 1 then
    return vim.lsp.get_clients({ method = method })
  else
    ---@diagnostic disable-next-line: deprecated
    local clients = vim.lsp.get_active_clients()
    return vim.tbl_filter(function(client)
      return client.supports_method(method)
    end, clients)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local bufnr = args.buf
    if client.supports_method("textDocument/semanticTokens") and vim.lsp.semantic_tokens then
      vim.keymap.set("n", "<localleader>st", function()
        vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false
        for _, cl in ipairs(get_clients()) do
          if cl.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](
              bufnr or 0,
              cl.id
            )
          end
        end
      end, { desc = "Toggle semantic tokens on buffer", buffer = bufnr or 0 })
    end
  end,
}) -- }}}

-- Range formatting {{{

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

local function format_range_operator(disabled_servers) --{{{
  local old_func = vim.go.operatorfunc
  -- selene: allow(global_usage)
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

local function document_range_formatting(disabled_servers) --{{{
  quick.buffer_command("Format", function(args)
    format_command(disabled_servers, args.range ~= 0, args.line1, args.line2, args.bang)
  end, { range = true })
  xnoremap("gq", function()
    local line1, _ = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local line2, _ = unpack(vim.api.nvim_buf_get_mark(0, "]"))
    if line1 > line2 then
      line1, line2 = line2, line1
    end
    format_command(disabled_servers, true, line1, line2, false)
  end, "Format range")
  nnoremap("gq", function()
    format_range_operator(disabled_servers)
  end, "Format range")

  vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:3000})"
end --}}}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/rangeFormatting") then
      document_range_formatting({})
    end
  end,
}) -- }}}

-- Code action {{{

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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/codeAction") then
      quick.buffer_command("CodeAction", function(c_args)
        code_action(c_args.range ~= 0, c_args.line1, c_args.line2)
      end, { range = true })
      nnoremap("gra", code_action, "Code action")
      xnoremap("gra", ":'<,'>CodeAction<CR>", "Code action")
    end
  end,
}) -- }}}

---@param client lspclient
local function capability_callbacks(client)
  local name = client.name
  local callbacks = server_callbacks[name]
  if callbacks then
    return callbacks
  end

  callbacks = {}

  -- Contains functions to be run before writing the buffer. The format
  -- function will format the while buffer, and the imports function will
  -- organise imports.
  local imports_hook = function() end
  local format_hook = function() end
  local caps = client.server_capabilities
  if client.supports_method("textDocument/codeAction") then -- {{{
    -- Either is it set to true, or there is a specified set of
    -- capabilities. Sumneko doesn't support it, but the
    -- client.supports_method returns true.
    local can_organise_imports = type(caps.codeActionProvider) == "table"
      and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
    if can_organise_imports then
      table.insert(callbacks, lsp_util.setup_organise_imports)
      imports_hook = lsp_util.lsp_organise_imports
    end
  end -- }}}

  if client.supports_method("textDocument/formatting") then -- {{{
    table.insert(callbacks, lsp_util.document_formatting)
    local disabled_servers = {
      "lua_ls",
      "jsonls",
      "sqls",
      "html",
    }
    format_hook = function()
      vim.lsp.buf.format({
        async = false,
        filter = function(server)
          return not vim.tbl_contains(disabled_servers, server.name)
        end,
      })
    end
  end -- }}}

  -- Setup import format eveents {{{
  table.insert(callbacks, function(cl, bufnr)
    lsp_util.setup_events(cl, imports_hook, format_hook, bufnr)
  end) -- }}}

  local workspace_folder_supported = caps.workspace -- {{{
    and caps.workspace.workspaceFolders
    and caps.workspace.workspaceFolders.supported
  if workspace_folder_supported then
    table.insert(callbacks, lsp_util.workspace_folder_properties)
  end -- }}}

  server_callbacks[name] = callbacks
  return callbacks
end

---The function to pass to the LSP's on_attach callback.
---@param client lspclient
---@param bufnr number
local function on_attach(client, bufnr) --{{{
  vim.api.nvim_buf_call(bufnr, function()
    local callbacks = capability_callbacks(client)
    for _, callback in ipairs(callbacks) do
      callback(client, bufnr)
    end

    lsp_util.setup_diagnostics(bufnr)
    lsp_util.support_commands()
  end)
end --}}}

return {
  on_attach = on_attach,
}

-- vim: fdm=marker fdl=0
