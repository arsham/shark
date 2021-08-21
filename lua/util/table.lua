function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end
    return sliced
end

function table.length(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- usage: for v in values({1, 2, 3}) do print(v) end
function table.values(tbl)
    local i = 0
    return function() i = i + 1; return tbl[i] end
end

function table.merge(tbl1, tbl2)
    local tmp = {}
    for _, v in ipairs(tbl1) do table.insert(tmp, v) end
    for _, v in ipairs(tbl2) do table.insert(tmp, v) end
    return tmp
end

function table.contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end
