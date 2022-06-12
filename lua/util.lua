local M = {}

---Returns true if the buffer has the name variable. If it does not, it sets
-- the variable and returns false.
-- @param name The name of the variable to check.
-- @return boolean
function M.buffer_has_var(name)
  local ok, _ = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok then
    return true
  end
  vim.api.nvim_buf_set_var(0, name, true)
  return false
end

return M
