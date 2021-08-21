function _G.buf_list()
    local list = vim.fn.getbufinfo({buflisted = 1})
    local ret = {}
    for _, v in pairs(list) do
        local t = {
            string.format("%3d", v.bufnr),
            "   ",
            v.name,
        }
        if v.changed > 0 then
            t[2] = "[+]"
        end
        table.insert(ret, table.concat(t, " "))
    end
    return ret
end

function _G.buf_delete(names)
    for _, name in pairs(names) do
        local num = string.match(name, '%d+')
        pcall(vim.api.nvim_buf_delete, num, {})
    end
end

-- Returns a list of marks and the file names.
function _G.mark_list()
    local list = vim.fn.getmarklist()
    local bufnr = vim.fn.bufnr()
    for _, v in pairs(vim.fn.getmarklist(bufnr)) do
        v.file = vim.fn.bufname(bufnr)
        table.insert(list, v)
    end

    local t = {
        string.format("mark %5s %3s %s", 'line', 'col', 'file/text')
    }
    for _, item in pairs(list) do
        if string.match(string.lower(item.mark), '[a-z]') then
            local str = string.format(" %s %5d %3d %s",
                string.sub(item.mark, 2, 2), item.pos[2], item.pos[3], item.file)
            table.insert(t, str)
        end
    end
    return t
end

-- Deletes a list of marks by their names.
-- @param names(table)
function _G.mark_delete(names)
    for _, name in pairs(names) do
        local mark = string.match(name, '%a')
        vim.cmd('delmarks ' .. mark)
    end
end

-- Returns a list of files under current directory that are not in the args
-- list.
function _G.files_not_in_args()
    local list = vim.fn.systemlist('fd . -t f')
    local args = vim.fn.argv()
    local seen = {}
    local ret = {}
    for _, v in pairs(args) do
        seen[v] = true
    end

    for _, v in pairs(list) do
        if not seen[v] then
            table.insert(ret, v)
        end
    end
    return ret
end

-- ArgsAdd adds items in the lines to the args.
function _G.args_add(lines)
    vim.cmd('arga ' .. table.concat(lines, " "))
end

function _G.args_delete(lines)
    vim.cmd('argd ' .. table.concat(lines, " "))
end

function _G.reload_config_files(list)
    for _, name in pairs(list) do
        vim.cmd(string.format("luafile %s", name))
    end
end
