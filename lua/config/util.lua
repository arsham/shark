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
---@param plugin string
---@return boolean
function M.is_enabled(plugin)
  if not plugins[plugin] then
    return true
  end
  return plugins[plugin].enabled
end

---Returns true if the plugin should be loaded. Disabled plugins are listed in
-- the plugins table.
---@param plugin string
---@return boolean
function M.should_start(plugin)
  if not plugins[plugin] then
    return true
  end
  return plugins[plugin].start
end

return M
