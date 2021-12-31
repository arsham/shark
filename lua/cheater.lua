local util = require('util')

local items = {
    "",
    "go",
    "postgresql",
    "lua",
    "vim",
    "git",

    "Bash-Snippets",
    "MegaCli",
    "alias",
    "base32",
    "base64",
    "basename",
    "bash",
    "bat",
    "bzip2",
    "cat",
    "curl",
    "docker",
    "env",
    "fd",
    "find",
    "fzf",
    "gpg",
    "gpg2",
    "grep",
    "gzip",
    "helm",
    "journalctl",
    "jq",
    "kubectl",
    "locate",
    "lsof",
    "makepkg",
    "meteor",
    "pacman",
    "redis",
    "ripgrep",
    "systemctl",
    "tmux",
    "xargs",
    "yay",
    "zsh",
}

local last_query = ""
local last_section = ""
local last_mode = false

local function curl(section, query, no_comment)
    query = query:gsub("^%s+", "")
    query = query:gsub("%s+$", "")
    if query == "" then return end

    last_query = query
    last_mode = no_comment
    last_section = section

    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    local separator = "/"
    local flag = ""
    if no_comment then flag = "Q" end

    if section == "ripgrep" then
        section = "rg"
    elseif section == "" then
        separator = ""
    end
    query = query:gsub("%s","+")

    local cmd = table.concat({
        'https://cht.sh/',
        section, separator, query,
        '?', flag, "T",
    }, "")

    local job = require('plenary.job')
    job:new({
        command = "curl",
        args = {"-s", cmd},
        on_exit = function(j, exit_code)
            local res = j:result()
            local has_error = false
            local error_msg = "404 NOT FOUND"

            for i = 1, 5 do
                if res[i] and string.match(res[i], error_msg) then
                    has_error = true
                end
            end

            if exit_code ~=0 or has_error then
                res = table.concat({
                    cmd,
                    table.concat(j:stderr_result(), "\n"),
                    table.concat(res, "\n"),
                }, "\n")
                local type = vim.lsp.log_levels.ERROR
                vim.notify(res, type, {
                    title = "Getting cheatsheet",
                    timeout = 4000,
                })
                return
            end

            vim.schedule(function()
                vim.fn.append(cur_line, res)
                local motion = ''
                if #res > 1 then
                    motion = string.format('%dj', #res - 1)
                end
                util.normal('n', string.format('jV%s', motion))
            end)
        end,
    }):start()
end

local function invoke(no_comment, query)
    if query == nil then
        local cur_line = vim.api.nvim_win_get_cursor(0)[1]
        query = vim.fn.getline(cur_line, cur_line)[1]
    end
    local wrapped = vim.fn["fzf#wrap"]({
        source = items,
        options = [[--prompt "Section (optional)> " +m]],
    })
    wrapped["sink*"] = function(section)
        curl(section[2], query, no_comment)
    end
    vim.fn["fzf#run"](wrapped)
end

util.nnoremap{'<leader>cs', function() invoke(true) end,  silent=true}
util.nnoremap{'<leader>cq', function() invoke(false) end, silent=true}
util.nnoremap{'<leader>cn', function()
    if last_query == "" then
        vim.notify("No previous cheat query", "error", {
            title = "Error",
            timeout = 5000,
        })
        return
    end

    local query = last_query .. "\\1"
    local num = last_query:match('\\(%d+)$')
    if num then
        num = tonumber(num) + 1
        query = last_query:gsub('\\(%d+)$', "\\" .. num)
    end

    curl(last_section, query, last_mode)
end, silent=true}
