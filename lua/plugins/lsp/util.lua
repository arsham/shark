---@diagnostic disable: duplicate-set-field, param-type-mismatch
local M = {}

local quick = require("arshlib.quick")
local augroup = require("config.util").augroup

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
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
