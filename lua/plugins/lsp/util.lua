---@diagnostic disable: duplicate-set-field, param-type-mismatch
local M = {}

local quick = require("arshlib.quick")
local augroup = require("config.util").augroup

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
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
