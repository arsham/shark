local nvim = require('nvim')
local util = require('util')

local M = {}

---Launches a ripgrep search with a fzf search interface.
---@param term? string if empty, the search will only happen on the content.
---@param no_ignore? string disables the ignore rules.
function M.ripgrep_search(term, no_ignore)
    term = vim.fn.shellescape(term)
    local nth       = ''
    local with_nth  = ''
    local delimiter = ''
    if term then
        with_nth  = '--nth 2..'
        nth       = '--nth 1,4..'
        delimiter = '--delimiter :'
    end
    no_ignore = no_ignore and '' or '--no-ignore'

    local rg_cmd = table.concat({
        'rg',
        '--line-number', '--column',
        '--no-heading',
        '--color=always',
        '--smart-case',
        '--hidden',
        '-g "!.git/" ', no_ignore,
        '--', term,
    }, " ")

    local args = {
        options = table.concat({
            '--prompt="Search in files> "',
            '--preview-window nohidden',
            delimiter,
            with_nth,
            nth,
        }, ' ')
    }

    local preview = vim.fn["fzf#vim#with_preview"](args)
    vim.fn["fzf#vim#grep"](rg_cmd, 1, preview)
end

---Launches a ripgrep search with a fzf search interface.
---@param term? string if empty, the search will only happen on the content.
---@param no_ignore? string disables the ignore rules.
function M.ripgrep_search_incremental(term, no_ignore)
    term = vim.fn.shellescape(term)
    local query     = ''
    local nth       = ''
    local with_nth  = ''
    local delimiter = ''
    if term then
        query     = '--query ' .. term
        with_nth  = '--nth 2..'
        nth       = '--nth 1,4..'
        delimiter = '--delimiter :'
    end
    no_ignore = no_ignore and '' or '--no-ignore'

    local rg_cmd = table.concat({
        'rg',
        '--line-number', '--column',
        '--no-heading',
        '--color=always',
        '--smart-case',
        '--hidden',
        '-g "!.git/" ', no_ignore,
        '-- %s || true',
    }, " ")

    local initial = string.format(rg_cmd, term)
    local reload_cmd = string.format(rg_cmd, '{q}')

    local args = {
        options = table.concat({
            '--prompt="1. Ripgrep> "',
            '--header="<Alt-Enter>:Reload on current query"',
            '--header-lines=1',
            '--preview-window nohidden',
            '--phony', '--disabled',
            query,
            '--bind',
            string.format("'change:reload:%s'", reload_cmd),
            '--bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. FZF> )+enable-search+clear-query"',
            delimiter,
            with_nth,
            nth,
        }, ' ')
    }

    local preview = vim.fn["fzf#vim#with_preview"](args)
    vim.fn["fzf#vim#grep"](initial, 1, preview)
end

function M.delete_buffer()
    local list = vim.fn.getbufinfo({buflisted = 1})
    local buf_list = {
        table.concat({'', '', '', 'Buffer', '', 'Filename', ''}, '\t'),
    }
    local cur_buf = vim.fn.bufnr('')
    local alt_buf = vim.fn.bufnr('#')

    for _, v in pairs(list) do
        local name = vim.fn.fnamemodify(v.name, ":~:.")
        -- the bufnr can't go to the first item otherwise it breaks the preview
        -- line
        local t = {
            string.format('%s:%d', v.name, v.lnum),
            v.lnum,
            tostring(v.bufnr),
            string.format('[%s]', util.ansi_color(util.colours.red, v.bufnr)),
            '',
            name,
            '',
        }
        local signs = ''
        if v.bufnr == cur_buf then
            signs = signs .. util.ansi_color(util.colours.red, '%')
        end
        if v.bufnr == alt_buf then
            signs = signs .. '#'
        end
        t[5] = signs
        if v.changed > 0 then
            t[7] = "[+]"
        end
        table.insert(buf_list, table.concat(t, "\t"))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = buf_list,
        options = table.concat({
            '--prompt "Delete Buffers > "',
            '--multi', '--exit-0',
            '--ansi',
            "--delimiter '\t'",
            '--with-nth=4..', '--nth=3',
            "--bind 'ctrl-a:select-all+accept'",
            '--preview-window +{3}+3/2,nohidden',
            '--tiebreak=index',
            '--header-lines=1',
        }, ' '),
        placeholder = "{1}",
    })

    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview['sink*'] = function(names)
        for _, name in pairs({unpack(names, 2)}) do
            local num = tonumber(name:match('^[^\t]+\t[^\t]+\t([^\t]+)\t'))
            pcall(vim.api.nvim_buf_delete, num, {})
        end
    end
    vim.fn["fzf#run"](preview)
end

---Searches in the lines of current buffer. It provides an incremental search
---that would switch to fzf filtering on <Alt-Enter>.
function M.lines_grep()
    local options = table.concat({
        '--prompt="Current Buffer> "',
        '--header="<CR>:jumps to line, <C-w>:adds to locallist, <C-q>:adds to quickfix list"',
        '--layout reverse-list',
        '--delimiter="\t"',
        '--with-nth=3..',
        '--preview-window nohidden',
    }, ' ')
    local filename = vim.fn.fnameescape(vim.fn.expand('%'))
    local rg_cmd = {
        'rg', '.',
        '--line-number',
        '--no-heading',
        '--color=never',
        '--smart-case',
        filename,
    }
    local got = vim.fn.systemlist(rg_cmd)
    local source = {}
    for _, line in pairs(got) do
        local num, content = line:match('^(%d+):(.+)$')
        table.insert(source, string.format('%s:%d\t%d\t%s', filename, num, num, content))
    end
    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = options,
        placeholder = '{1}',
    })

    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview['sink*'] = function(names)
        if #names == 0 then return end
        local action = names[1]
        if #action > 0 then
            local fn = FzfActions[action]
            if fn then
                names = _t{unpack(names, 2)}
                local filenames = _t()

                names:map(function(v)
                    local name, line = v:match('^([^:]+):([^\t]+)\t')
                    filenames:insert({
                        filename = vim.fn.fnameescape(name),
                        lnum     = tonumber(line),
                        col      = 1,
                        text     = "Added with fzf selection",
                    })
                end)
                fn(filenames)
            end
        end

        if #names == 2 then
            local num = names[2]:match('^[^:]+:(%d+)\t')
            util.normal('n', string.format('%dgg', num))
        end
    end
    vim.fn["fzf#run"](preview)
end

---Launches a fzf search for reloading config files.
---@param watch boolean if true it will keep watching for changes.
function M.reload_config(watch)
    local loc = vim.env['MYVIMRC']
    local base_dir = require('plenary.path'):new(loc):parents()[1]
    local got = vim.fn.systemlist({'fd', '.', '-e', 'lua', '-t', 'f', '-L', base_dir})
    local source = {}
    for _, name in ipairs(got) do
        table.insert(source, ('%s\t%s'):format(name, vim.fn.fnamemodify(name, ":~:.")))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--prompt="Open Config> "',
            '--header="<C-a>:Reload all"',
            '--delimiter="\t"',
            '--with-nth=2..', '--nth=1',
            '--multi',
            '--bind ctrl-a:select-all+accept',
            '--preview-window +{3}+3/2,nohidden',
            '--tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview["sink*"] = function(list)
        local names = {}
        for _, name in pairs({unpack(list, 2)}) do
            name = name:match('^[^\t]*')
            table.insert(names, name)
        end
        if watch then
            require('commands').watch_file_changes(names)
            return
        end
        for _, name in pairs(names) do
            name = name:match('^[^\t]*')
            local mod, ok = util.file_module(name)
            if ok then
                package.loaded[mod] = nil
                require(mod)
            end
        end
    end
    vim.fn["fzf#run"](preview)
end

function M.open_config()
    local path = vim.fn.expand('~/.config/nvim')
    local got = vim.fn.systemlist({'fd', '.', '-t', 'f', '-F', path})
    local source = {}
    for _, name in ipairs(got) do
        table.insert(source, ('%s\t%s'):format(name, vim.fn.fnamemodify(name, ":~:.")))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--prompt="Open Config> "',
            '+m',
            '--with-nth=2..', '--nth=1',
            '--delimiter="\t"',
            "--preview-window +{3}+3/2,nohidden",
            '--tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview["sink*"] = function() end
    preview["sink"] = function(filename)
        filename = filename:match('^[^\t]*')
        if filename ~= '' then
            nvim.ex.edit(filename)
        end
    end
    vim.fn["fzf#run"](preview)
end

function M.delete_marks()
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
            '--prompt="Delete Mark> "',
            '--header="<C-a>:Delete all"',
            '--header-lines=1',
            '--delimiter="\t"',
            '--with-nth=2..', '--nth=3',
            '--multi',
            '--exit-0',
            '--bind ctrl-a:select-all+accept',
            "--preview-window +{3}+3/2,nohidden",
            '--tiebreak=index',
        }, ' '),
        placeholder = "{1}",
    })
    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview['sink*'] = function(names)
        for _, name in pairs({unpack(names, 2)}) do
            local mark = string.match(name, '^[^\t]+\t(%a)')
            nvim.ex.delmarks(mark)
        end
    end
    vim.fn["fzf#run"](preview)
end

function M.git_grep(term)
    local format = '--format=format:%H\t* %h\t%ar\t%an\t%s\t%d'
    local source = vim.fn.systemlist({'git', '--no-pager', 'log', '-G', term, format})
    local wrapped = vim.fn["fzf#wrap"]({
        source = source,
        options = table.concat({
            '--prompt="Search in tree> "',
            '+m',
            '--delimiter="\t"',
            '--with-nth=2..', '--nth=1',
            '--tiebreak=index',
            '--preview-window +{3}+3/2,~1,nohidden',
            '--exit-0',
            '--preview', '"',
            [[echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |]],
            "xargs -I % sh -c 'git show --color=always %'",
            '"',
        }, ' '),
        placeholder = "{1}",
    })

    wrapped["sink*"] = function(list)
        for _, sha in pairs(list) do
            sha = sha:match('^[^\t]*')
            if sha ~= "" then
                local toplevel = vim.fn.system("git rev-parse --show-toplevel")
                toplevel = string.gsub(toplevel, "\n", '')
                local str = string.format([[fugitive://%s/.git//%s]], toplevel, sha)
                nvim.ex.edit(str)
            end
        end
    end
    vim.fn["fzf#run"](wrapped)
end

function M.checkout_branck()
    local current = vim.fn.system('git symbolic-ref --short HEAD')
    current = current:gsub("\n", "")
    local current_escaped = current:gsub("/", "\\/")

    local cmd = table.concat({
        'git',
        'branch',
        '-r',
        '--no-color |',
        'sed',
        '-r',
        "-e 's/^[^/]*\\///'",
        "-e '/^",
        current_escaped,
        "$/d' -e '/^HEAD/d' | sort -u",
    })
    local opts = {
        sink = function(branch)
            vim.fn.system('git checkout ' .. branch)
        end,
        options = {'--no-multi', '--header=' .. current}
    }
    vim.fn["fzf#vim#grep"](cmd, 0, opts)
end

function M.open_todo()
    local cmd = table.concat({
        'rg',
        '--line-number', '--column',
        '--no-heading',
        '--color=always',
        '--smart-case',
        '--hidden', '-g "!.git/"',
        '--',
        '"fixme|todo"',
    }, " ")
    vim.fn["fzf#vim#grep"](cmd, 1, vim.fn["fzf#vim#with_preview"]())
end

function M.args_add()
    local seen = _t()
    _t(vim.fn.argv()):map(function(v)
        seen[v] = true
    end)

    local files = _t()
    _t(vim.fn.systemlist({'fd', '.', '-t', 'f'}))
    :map(function(v)
        return v:gsub("^./", "")
    end)
    :filter(function(v)
        return not seen[v]
    end)
    :map(function(v)
        table.insert(files, v)
    end)

    if files:length() == 0  then
        local msg = 'Already added everything from current folder'
        vim.notify(msg, vim.lsp.log_levels.WARN, {title = 'Adding Args'})
        return
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = files,
        options = '--multi --bind ctrl-a:select-all+accept',
    })
    wrapped['sink*'] = function(lines)
        nvim.ex.arga(lines)
    end
    vim.fn["fzf#run"](wrapped)
end

return M
