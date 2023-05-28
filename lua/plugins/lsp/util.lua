---@diagnostic disable: duplicate-set-field, param-type-mismatch
local M = {}

local quick = require("arshlib.quick")
local fzf = require("fzf-lua")

local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function inoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("i", key, fn, opts)
end --}}}

function M.setup_diagnostics(bufnr) --{{{
  nnoremap("<localleader>dd", vim.diagnostic.open_float, "show diagnostics")
  nnoremap("<localleader>dq", vim.diagnostic.setqflist, "populate quickfix")
  nnoremap("<localleader>dw", vim.diagnostic.setloclist, "populate local list")

  local next = function()
    quick.call_and_centre(vim.diagnostic.goto_next)
  end
  local prev = function()
    quick.call_and_centre(vim.diagnostic.goto_prev)
  end
  nnoremap("]d", next, "goto next diagnostic")
  nnoremap("[d", prev, "goto previous diagnostic")

  local ok, diagnostics = pcall(require, "fzf-lua.providers.diagnostic")
  -- stylua: ignore start
  quick.buffer_command("DiagLoc", function() vim.diagnostic.setloclist() end)
  quick.buffer_command("DiagQf",  function() vim.diagnostic.setqflist()  end)
  if ok then
    quick.buffer_command("Diagnostics",    function() diagnostics.diagnostics({}) end)
    quick.buffer_command("Diag",           function() diagnostics.diagnostics({}) end)
    quick.buffer_command("DiagnosticsAll", function() diagnostics.all({})         end)
    quick.buffer_command("DiagAll",        function() diagnostics.all({})         end)
  end
  -- stylua: ignore end
  quick.buffer_command("DiagnosticsDisable", function()
    vim.diagnostic.disable(bufnr)
  end)
  quick.buffer_command("DiagnosticsEnable", function()
    vim.diagnostic.enable(bufnr)
  end)
end --}}}

function M.hover() --{{{
  nnoremap("H", vim.lsp.buf.hover, "Show hover")
  inoremap("<M-h>", vim.lsp.buf.hover, "Show hover")
end --}}}

function M.goto_definition() --{{{
  local perform = function()
    fzf.lsp_definitions({ jump_to_single_result = true })
  end
  quick.buffer_command("Definition", perform)
  nnoremap("gd", perform, "Go to definition")
  vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
end --}}}

function M.signature_help() --{{{
  nnoremap("K", vim.lsp.buf.signature_help, "show signature help")
  inoremap("<M-l>", vim.lsp.buf.signature_help, "show signature help")
end --}}}

return M

-- vim: fdm=marker fdl=0
