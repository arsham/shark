local command = require('util').command

command{"Notes",    "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", attrs="-bang"}
command{"Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", attrs="-bang"}

-- command{"Todo",             "grep todo|fixme **/*", post_run="cw", silent=true}
command{"Todo", function()
    local cmd = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- "fixme|todo"'
    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"]())
end}

command{"Reload", function()
    local loc = vim.env['MYVIMRC']
    local base_dir = require('plenary.path'):new(loc):parents()[1]
    local wrap = vim.fn["fzf#wrap"]({
        source = ('fd . -e lua %s'):format(base_dir),
        options = '--multi --bind ctrl-a:select-all+accept',
    })
    wrap["sink*"] = function(list)
        for _, name in pairs(list) do
            vim.cmd(("luafile %s"):format(name))
        end
    end
    vim.fn["fzf#run"](wrap)
end}

command{"Config", function()
    local wrapped = vim.fn["fzf#wrap"]({
        source = 'fd . ~/.config/nvim',
        options = '--multi --bind ctrl-a:select-all+accept',
    })
    wrapped['sink*'] = nil
    vim.fn["fzf#run"](wrapped)
end}

-- Delete marks interactivly with fzf.
command{"MarksDelete", function()
    local list = vim.fn.getmarklist()
    local bufnr = vim.fn.bufnr()
    for _, v in pairs(vim.fn.getmarklist(bufnr)) do
        v.file = vim.fn.bufname(bufnr)
        table.insert(list, v)
    end

    local mark_list = {
        ("mark %5s %3s %s"):format('line', 'col', 'file/text'),
    }
    for _, item in pairs(list) do
        if string.match(string.lower(item.mark), '[a-z]') then
            local str = (" %s %5d %3d %s"):format(
                string.sub(item.mark, 2, 2), item.pos[2], item.pos[3], item.file)
            table.insert(mark_list, str)
        end
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = mark_list,
        options = '--multi --bind ctrl-a:select-all+accept --header-lines=1 --prompt="Delete Mark> "',
    })
    wrapped['sink*'] = function(names)
        for _, name in pairs(names) do
            local mark = string.match(name, '%a')
            if mark ~= nil then
                vim.cmd('delmarks ' .. mark)
            end
        end
    end
    vim.fn["fzf#run"](wrapped, vim.fn["fzf#vim#with_preview"]())
end}

command{"GGrep", attrs="-bang -nargs=*", function(term)
    local preview = vim.fn["fzf#vim#with_preview"]({
        dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    })
    vim.fn["fzf#vim#grep"](
        'git grep --line-number -- ' .. vim.fn.shellescape(term),
        0, preview, 0
    )
end}

-- Delete args interactivly with fzf.
command{"ArgsDelete", function()
    local wrapped = vim.fn["fzf#wrap"]({
        source = vim.fn.argv(),
        options = '--multi --bind ctrl-a:select-all+accept',
    })
    wrapped['sink*'] = function(lines)
        vim.cmd('argd ' .. table.concat(lines, " "))
    end
    vim.fn["fzf#run"](wrapped)
end}
command{"ArgDelete", "ArgsDelete"}

command{"ArgAdd", function()
    local list = vim.fn.systemlist('fd . -t f')
    local args = vim.fn.argv()
    local seen = {}
    local files = {}
    for _, v in pairs(args) do
        seen[v] = true
    end

    for _, v in pairs(list) do
        if not seen[v] then
            table.insert(files, v)
        end
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = files,
        options = '--multi --bind ctrl-a:select-all+accept',
    })
    wrapped['sink*'] = function(lines)
        vim.cmd('arga ' .. table.concat(lines, " "))
    end
    vim.fn["fzf#run"](wrapped)
end}
