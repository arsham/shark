function string.startswith(s, n)
	return s:sub(1, #n) == n
end

function string.endswith(self, str)
  return self:sub(-#str) == str
end

function string.title_case(str)
    return str:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
end

function string.split(str, sep)
    if sep == nil then
        sep = '%s'
    end

    local res = {}
    local func = function(w)
        table.insert(res, w)
    end

    string.gsub(str, '[^'..sep..']+', func)
    return res
end

function string.split_space(str)
    local chunks = {}
    for substring in str:gmatch("%S+") do
        table.insert(chunks, substring)
    end
    return chunks
end
