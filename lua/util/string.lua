function string.startswith(s, n)
	return s:sub(1, #n) == n
end

function string.endswith(self, str)
  return self:sub(-#str) == str
end

function string.title_case(str)
    return str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
end
