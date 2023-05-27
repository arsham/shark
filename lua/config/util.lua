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

return M
