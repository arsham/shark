local M = {}

---Runs the command in shell.
-- @param command string
-- @return table
M.shell = function(command) --{{{
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end --}}}

math.randomseed(os.time())
local charset = {} -- Random String {{{
for i = 48, 57 do
  table.insert(charset, string.char(i))
end
for i = 65, 90 do
  table.insert(charset, string.char(i))
end
for i = 97, 122 do
  table.insert(charset, string.char(i))
end
M.random_string = function(length)
  if length == 0 then
    return ""
  end
  return M.random_string(length - 1) .. charset[math.random(1, #charset)]
end --}}}

return M

-- vim: fdm=marker fdl=0
