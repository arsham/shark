---Returns true if the s starts with n.
---@param s string
---@param n string
---@return boolean
function string.startswith(s, n)
    return s:sub(1, #n) == n
end

---Returns true if the s ends with n.
---@param s string
---@param n string
---@return boolean
function string.endswith(s, n)
    return s:sub(-#n) == n
end

---Turns str into title case.
---@param str string
---@return string
function string.title_case(str)
    return str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
end

---Splits a string into a table of strings.
---@param str string
---@param sep? string if not provided it will split by spaces
---@return table
function string.split(str, sep)
    local res = _t()
    local pattern = string.format("([^%s]+)", sep or '%s')
    _ = str:gsub(pattern, function(w)
            table.insert(res, w)
    end)
    return res
end
