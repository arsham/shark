local command = require('util').command

command{"Notes",    "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", attrs="-bang"}
command{"Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", attrs="-bang"}

command{"Todo", function()
    local cmd = table.concat({
        'rg --column --line-number --no-heading --color=always',
        '   --smart-case --hidden -g "!.git/" -- "fixme|todo"',
    }, " ")
    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"]())
end}

command{"Reload", function()
    local loc = vim.env['MYVIMRC']
    local base_dir = require('plenary.path'):new(loc):parents()[1]
    local got = string.split(vim.fn.system(('fd . -e lua -t f -L %s'):format(base_dir)), '\n')
    local source = {}
    for _, name in ipairs(got) do
        table.insert(source, ('%s\t%s'):format(name, vim.fn.fnamemodify(name, ":~:.")))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--prompt="Open Config> " +m',
            '--with-nth=2.. --delimiter="\t"',
            '--multi --bind ctrl-a:select-all+accept',
            '--preview-window +{3}+3/2,nohidden',
            '-n 1 --tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    wrapped["sink*"] = function(list)
        for _, name in pairs(list) do
            name = name:match('^[^\t]*')
            if name ~= "" then
                vim.cmd(("luafile %s"):format(name))
            end
        end
    end
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    vim.fn["fzf#run"](preview)
end}

command{"Config", function()
    local got = string.split(vim.fn.system('fd . -t f -F ~/.config/nvim'), '\n')
    local source = {}
    for _, name in ipairs(got) do
        table.insert(source, ('%s\t%s'):format(name, vim.fn.fnamemodify(name, ":~:.")))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--prompt="Open Config> " +m',
            '--with-nth=2.. --delimiter="\t"',
            "--preview-window +{3}+3/2,nohidden",
            '-n 1 --tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    wrapped["sink"] = function(filename)
        filename = filename:match('^[^\t]*')
        if filename ~= '' then
            vim.cmd(':e ' .. filename)
        end
    end
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    vim.fn["fzf#run"](preview)
end}

-- Delete marks interactivly with fzf.
command{"MarksDelete", function()
    local list = vim.fn.getmarklist()
    local bufnr = vim.fn.bufnr()
    for _, v in pairs(vim.fn.getmarklist(bufnr)) do
        v.file = vim.fn.bufname(bufnr)
        table.insert(list, v)
    end
    local items = {}
    for _, v in pairs(list) do
        table.insert(items, {
            show_name = vim.fn.fnamemodify(v.file, ":~:."),
            mark = string.sub(v.mark, 2, 2),
            line = v.pos[2],
            col = v.pos[3],
            file = v.file,
        })
    end

    local mark_list = {
        ("666\tmark\t%5s\t%3s\t%s"):format('line', 'col', 'file/text'),
    }
    for _, item in pairs(items) do
        if string.match(string.lower(item.mark), '[a-z]') then
            local str = ("%s:%d\t%s\t%5d\t%3d\t%s"):format(
                item.show_name, item.line,
                item.mark,
                item.line,
                item.col,
                item.file
            )
            table.insert(mark_list, str)
        end
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = mark_list,
        options = table.concat({
            '--prompt="Delete Mark> " --multi --header-lines=1',
            '--bind ctrl-a:select-all+accept --with-nth=2.. --delimiter="\t"',
            "--preview-window +{3}+3/2,nohidden",
            '-n 3 --tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    wrapped['sink*'] = function(names)
        for _, name in pairs(names) do
            local mark = string.match(name, '%a')
            if mark ~= nil then
                vim.cmd('delmarks ' .. mark)
            end
        end
    end
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    vim.fn["fzf#run"](preview)
end}

command{"Marks", attrs="-bang -bar", docs="show marks", function()
    local home = vim.fn["fzf#shellescape"](vim.fn.expand('%'))
    local preview = vim.fn["fzf#vim#with_preview"]({
        placeholder = '$([ -r $(echo {4} | sed "s#^~#$HOME#") ] && echo {4} || echo ' .. home .. '):{2}',
        options = '--preview-window +{2}-/2',
    })
    vim.fn["fzf#vim#marks"](preview, 0)
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

-- Replacing the default ordering.
command{"History", attrs="-bang -nargs=*", function()
    vim.fn["fzf#vim#history"](vim.fn["fzf#vim#with_preview"]({
        options = '--no-sort',
    }))
end}

command{"Checkout", attrs="-bang -nargs=0", docs="checkout a branch", function()
    local current = vim.fn.system('git symbolic-ref --short HEAD')
    current = current:gsub("\n", "")
    local current_escaped = current:gsub("/", "\\/")

    local cmd = "git branch -r --no-color | sed -r -e 's/^[^/]*\\///' -e '/^" .. current_escaped .. "$/d' -e '/^HEAD/d' | sort -u"
    local opts = {
        sink = function(branch)
            vim.fn.system('git checkout ' .. branch)
        end,
        options = {'--no-multi', '--header=' .. current}
    }
    vim.fn["fzf#vim#grep"](cmd, 0, opts)
end}

---Switch git worktrees. It creates a new tab in the new location.
command{"Worktree", docs="switch git worktree", function()
    local cmd = "git worktree list | cut -d' ' -f1"
    local wrapped = vim.fn["fzf#wrap"]({
        source = cmd,
        options = {'--no-multi'},
    })
    wrapped['sink*'] = function(dir)
        local str = string.format("tabnew | tcd %s", dir[2])
        vim.cmd(str)
    end
    vim.fn["fzf#run"](wrapped)
end}
command{'WT', 'Worktree'}
