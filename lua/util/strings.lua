---Turns str into title case.
---@param str string
---@return string
function string.title_case(str)
  return str:gsub("(%l)(%w*)", function(a,b)
    return string.upper(a)..b
  end)
end
