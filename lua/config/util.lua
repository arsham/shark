local M = {}

local augroups = {}

---Returns a new augroup with the given name. If the name has been given before
---it will return the previous augroup.
---@param name string
---@return number
function M.augroup(name)
  if augroups[name] then
    return augroups[name]
  end
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  augroups[name] = group
  return group
end

local plugins = require("config.disabled_list")

---Returns true if the plugin is enabled. Disabled plugins are listed in the
-- plugins table.
---@param name string plugin name
---@return boolean
function M.is_enabled(name)
  if plugins[name] and not plugins[name].enabled then
    return false
  end
  return true
end

---Returns true if the plugin should be loaded. Disabled plugins are listed in
-- the plugins table.
---@param name string plugin name
---@return boolean
function M.should_start(name)
  if plugins[name] and not plugins[name].start then
    return false
  end
  return true
end

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

return M
