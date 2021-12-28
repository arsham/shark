---Returns parts of the table between first and last indices.
---@param tbl table
---@param first number
---@param last number
---@param step number the step between each index
---@return table
function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end
    return sliced
end

---Returns the length of the table.
---@param tbl table
---@return number
function table.length(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end


---Returns and iterator that produces values from the table.
---
---Example:
--- ```
--- for v in values({1, 2, 3}) do
---     print(v)
--- end
--- ```
---
---@param tbl table
---@return function
function table.values(tbl)
    local i = 0
    return function() i = i + 1; return tbl[i] end
end

---Merge two tables.
---@param tbl1 table
---@param tbl2 table
---@return table
function table.merge(tbl1, tbl2)
    local tmp = {}
    for _, v in ipairs(tbl1) do table.insert(tmp, v) end
    for _, v in ipairs(tbl2) do table.insert(tmp, v) end
    return tmp
end

---Return true of the table contains the value.
---@param tbl table
---@param val any
---@return boolean
function table.contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

---Return a reversed the table.
---@param t table
---@return table
function table.reverse(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

_ = math.randomseed(os.time())
---Shuffle the table.
---@param t table
function table.shuffle(t)
    local iterations = #t
    local j
    for i = iterations, 2, -1 do
        j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

---Returns true if the item is in the table.
---@param t table
---@param item any
---@return boolean
function table.any(t, item)
    for _, k in pairs(t) do
        if k == item then
            return true
        end
    end
    return false
end
