---@class HighlightOpt
---@field style string
---@field link? string if defined, everything else is ignored
---@field guifg string
---@field guibg string
---@field guisp string
---@field ctermfg string
---@field ctermbg string

---@class Quick
---@field command fun(name: string, command: string|function, opts?: table) Creates a command from provided specifics.
---@field normal fun(mode: string, motion: string, special: boolean?) Executes a command in normal mode.
---@field selection_contents fun(): string Returns the contents of the visually selected region.
---@field buffer_command fun(name: string, command: string|function, opts?: table) Creates a command from provided specifics on current buffer.
---@field call_and_centre fun(fn: fun()) Pushes the current location to the jumplist and calls the fn callback, then centres the cursor.
---@field highlight fun(group: string, opt: HighlightOpt) --Create a highlight group.

local M = {}

---Returns true if the buffer has the name variable. If it does not, it sets
-- the variable and returns false.
-- @param name The name of the variable to check.
-- @return boolean
function M.buffer_has_var(name) --{{{
  local ok, _ = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok then
    return true
  end
  vim.api.nvim_buf_set_var(0, name, true)
  return false
end --}}}

function M.full_start()
  return not vim.env.NVIM_START_LIGHT
end
function M.lsp_enabled()
  return not vim.env.NVIM_STOP_LSP
end
function M.full_start_with_lsp()
  return M.full_start() and M.lsp_enabled()
end

return M

-- vim: fdm=marker fdl=0
