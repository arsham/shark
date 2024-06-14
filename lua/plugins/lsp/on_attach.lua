local quick = require("arshlib.quick")
local fzf = require("fzf-lua")
local util = require("config.util")
local augroup = require("config.util").augroup
local get_clients = require("config.util").get_clients

local function nnoremap(key, fn, bufnr, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = bufnr, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function inoremap(key, fn, bufnr, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = bufnr, silent = true, desc = desc }, opts or {})
  vim.keymap.set("i", key, fn, opts)
end --}}}
local function xnoremap(key, fn, bufnr, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = bufnr, silent = true, desc = desc }, opts or {})
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
      nnoremap("grr", perform, args.buf, "Go to references")
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
      nnoremap("H", vim.lsp.buf.hover, args.buf, "Show hover")
      inoremap("<M-h>", vim.lsp.buf.hover, args.buf, "Show hover")
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
      nnoremap("gd", perform, args.buf, "Go to definition")
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
      nnoremap("K", vim.lsp.buf.signature_help, args.buf, "show signature help")
      inoremap("<M-l>", vim.lsp.buf.signature_help, args.buf, "show signature help")
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
      nnoremap("<localleader>@", perform, args.buf, "Document symbol")
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
      nnoremap("grn", function()
        return ":Rename " .. vim.fn.expand("<cword>")
      end, args.buf, "Incrementally rename symbol", { expr = true })
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
      nnoremap("<localleader>gi", perform, args.buf, "Go to implementation")
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
      end, args.buf, "Go to declaration")
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
      quick.buffer_command("CodeLensRefresh", function()
        vim.lsp.codelens.refresh({ bufnr = args.buf })
      end)
      quick.buffer_command("CodeLensRun", vim.lsp.codelens.run)
      nnoremap("<localleader>cr", vim.lsp.codelens.run, args.buf, "run code lenses")
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
      nnoremap("<localleader>gc", fzf.lsp_incoming_calls, args.buf, "show incoming calls")
      quick.buffer_command("Callees", fzf.lsp_outgoing_calls)
    end
  end,
}) -- }}}

-- Semantic tokens {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/semanticTokens") and vim.lsp.semantic_tokens then
      nnoremap("<localleader>st", function()
        vim.b.semantic_tokens_enabled = vim.b.semantic_tokens_enabled == false
        for _, cl in ipairs(get_clients()) do
          if cl.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](
              args.buf,
              cl.id
            )
          end
        end
      end, args.buf, "Toggle semantic tokens on buffer")
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

local function document_range_formatting(bufnr, disabled_servers) --{{{
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
  end, bufnr, "Format range")
  nnoremap("gq", function()
    format_range_operator(disabled_servers)
  end, bufnr, "Format range")

  vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:3000})"
end --}}}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/rangeFormatting") then
      document_range_formatting(args.buf, {})
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
      nnoremap("gra", code_action, args.buf, "Code action")
      xnoremap("gra", ":'<,'>CodeAction<CR>", args.buf, "Code action")
    end
  end,
}) -- }}}

-- Workspace folder properties {{{
local function workspace_folder_properties() --{{{
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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local caps = client.server_capabilities
    if not caps then
      return
    end
    local workspace_folder_supported = caps.workspace
      and caps.workspace.workspaceFolders
      and caps.workspace.workspaceFolders.supported
    if workspace_folder_supported then
      workspace_folder_properties()
    end
  end,
}) -- }}}

-- Formatting and imports {{{
local function lsp_organise_imports() --{{{
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

local function setup_organise_imports(bufnr) --{{{
  quick.buffer_command("Imports", lsp_organise_imports, { desc = "Organise imports" })
  nnoremap("<localleader>i", lsp_organise_imports, bufnr, "Organise imports")
end --}}}

-- Blanket formatting {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.supports_method("textDocument/formatting") then
      nnoremap("<localleader>gq", vim.lsp.buf.format, args.buf, "Format buffer")
    end
  end,
}) -- }}}

local disabled_servers = {
  "lua_ls",
  "jsonls",
  "sqls",
  "html",
}

-- Both formatting and imports {{{

local lsp_formatting_imports = augroup("lsp_formatting_imports")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local caps = client.server_capabilities
    if not caps then
      return
    end
    local can_organise_imports = type(caps.codeActionProvider) == "table"
      and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
    if not client.supports_method("textDocument/formatting") or not can_organise_imports then
      return
    end

    setup_organise_imports(args.buf)

    if not util.buffer_has_var("lsp_formatting_imports_" .. client.name) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_formatting_imports,
        buffer = args.buf,
        callback = function()
          lsp_organise_imports()
          if not require("config.constants").disable_formatting then
            vim.lsp.buf.format({
              async = false,
              filter = function(server)
                return not vim.tbl_contains(disabled_servers, server.name)
              end,
            })
          end
        end,
        desc = "formatting and imports",
      })
    end
  end,
})
-- }}}

-- Formatting only {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local caps = client.server_capabilities
    if not caps then
      return
    end
    local can_organise_imports = type(caps.codeActionProvider) == "table"
      and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
    if not client.supports_method("textDocument/formatting") or can_organise_imports then
      return
    end

    if not util.buffer_has_var("lsp_formatting_" .. client.name) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_formatting_imports,
        buffer = args.buf,
        callback = function()
          if not require("config.constants").disable_formatting then
            vim.lsp.buf.format({
              async = false,
              filter = function(server)
                return not vim.tbl_contains(disabled_servers, server.name)
              end,
            })
          end
        end,
        desc = "formatting only",
      })
    end
  end,
})
-- }}}

-- Importing only {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local caps = client.server_capabilities
    if not caps then
      return
    end
    local can_organise_imports = type(caps.codeActionProvider) == "table"
      and _t(caps.codeActionProvider.codeActionKinds):contains("source.organizeImports")
    if client.supports_method("textDocument/formatting") or not can_organise_imports then
      return
    end

    setup_organise_imports()
    if not util.buffer_has_var("lsp_imports_" .. client.name) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_formatting_imports,
        buffer = args.buf,
        callback = function()
          lsp_organise_imports()
        end,
        desc = "imports only",
      })
    end
  end,
})
-- }}}
-- }}}

-- Diagnostics {{{
-- Diagnostics bindings {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    nnoremap("<localleader>dd", vim.diagnostic.open_float, args.buf, "show diagnostics")
    nnoremap("<localleader>dq", vim.diagnostic.setqflist, args.buf, "populate quickfix")
    nnoremap("<localleader>dw", vim.diagnostic.setloclist, args.buf, "populate local list")

    local jump = function(fn, severity)
      return function()
        fn({ severity = severity and vim.diagnostic.severity[severity] or nil })
      end
    end

    local dNext = jump(vim.diagnostic.goto_next)
    local dPrev = jump(vim.diagnostic.goto_prev)
    local eNext = jump(vim.diagnostic.goto_next, "ERROR")
    local ePrev = jump(vim.diagnostic.goto_prev, "ERROR")
    local wNext = jump(vim.diagnostic.goto_next, "WARN")
    local wPrev = jump(vim.diagnostic.goto_prev, "WARN")
    local repeat_ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if repeat_ok then
      dNext, dPrev = ts_repeat_move.make_repeatable_move_pair(dNext, dPrev)
      eNext, ePrev = ts_repeat_move.make_repeatable_move_pair(eNext, ePrev)
      wNext, wPrev = ts_repeat_move.make_repeatable_move_pair(wNext, wPrev)
    end

    -- stylua: ignore start
    nnoremap("]d", function() quick.call_and_centre(dNext) end, args.buf, "goto next diagnostic")
    nnoremap("[d", function() quick.call_and_centre(dPrev) end, args.buf, "goto previous diagnostic")
    nnoremap("]e", function() quick.call_and_centre(eNext) end, args.buf, "goto next error")
    nnoremap("[e", function() quick.call_and_centre(ePrev) end, args.buf, "goto previous error")
    nnoremap("]W", function() quick.call_and_centre(wNext) end, args.buf, "goto next warning")
    nnoremap("[W", function() quick.call_and_centre(wPrev) end, args.buf, "goto previous warning")
    -- stylua: ignore end
  end,
})
-- }}}

-- Diagnostics commands {{{
vim.api.nvim_create_autocmd("LspAttach", {
  -- stylua: ignore
  callback = function(args)
    quick.buffer_command("DiagLoc", function() vim.diagnostic.setloclist() end)
    quick.buffer_command("DiagQf", function() vim.diagnostic.setqflist() end)
    quick.buffer_command("DiagFloat", function() vim.diagnostic.open_float() end)

    local ok, diagnostics = pcall(require, "fzf-lua.providers.diagnostic")
    if ok then
      quick.buffer_command("Diagnostics", function() diagnostics.diagnostics({}) end)
      quick.buffer_command("Diag", function() diagnostics.diagnostics({}) end)
      quick.buffer_command("DiagnosticsAll", function() diagnostics.all({}) end)
      quick.buffer_command("DiagAll", function() diagnostics.all({}) end)
    end

    local bufnr = args.buf
    quick.buffer_command("DiagnosticsDisable", function()
      vim.diagnostic.enable(false, { bufnr = bufnr })
    end)
    quick.buffer_command("DiagnosticsEnable", function()
      vim.diagnostic.enable(true, { bufnr = bufnr })
    end)
  end,
})
-- }}}
-- }}}

-- List workspace command {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    quick.buffer_command("ListWorkspace", function()
      vim.notify(vim.lsp.buf.list_workspace_folders(), vim.lsp.log_levels.INFO, {
        title = "Workspace Folders",
        timeout = 3000,
      })
    end)
  end,
}) -- }}}

-- Detach command {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    quick.buffer_command("Detach", function()
      for _, client in pairs(get_clients()) do
        vim.lsp.buf_detach_client(client.bufnr or 0, client.id)
      end
    end, { desc = "Detach the LSP server from the current buffer" })
  end,
}) -- }}}

-- Restart lsp command {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    ---Restats the LSP server. Fixes the problem with the LSP server not
    -- restarting with LspRestart command.
    local function restart_lsp()
      vim.cmd.LspStop()
      vim.defer_fn(function()
        vim.cmd.LspStart()
      end, 1000)
    end
    quick.buffer_command("RestartLsp", restart_lsp)
    nnoremap("<localleader>dr", restart_lsp, args.buf, "Restart LSP server")
  end,
}) -- }}}

-- Reload workspace {{{
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
-- }}}

-- vim: fdm=marker fdl=0
