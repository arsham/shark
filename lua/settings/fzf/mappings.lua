if not pcall(require, 'astronauta.keymap') then return end
local nvim = require('nvim')
local keymap = vim.keymap
local util = require('util')

-- This options: --tac will reverse the source data.

keymap.nnoremap{'<leader>:', ':Commands<CR>'}
keymap.nnoremap{'<C-p>', ':Files<CR>',    silent=true}
keymap.nnoremap{'<M-p>', ':Files ~/<CR>', silent=true}
keymap.nnoremap{'<C-b>', ':Buffers<CR>',  silent=true}
keymap.nnoremap{'<M-/>', ':Lines<CR>',    silent=true}

keymap.nnoremap{'<M-b>', silent=true, function()
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
            signs = signs .. '%'
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
            "--exit-0 --multi --ansi --delimiter '\t'",
            '--with-nth=4.. --nth=3',
            "--bind 'ctrl-a:select-all+accept' --preview-window +{3}+3/2,nohidden",
            '--tiebreak=index --header-lines=1',
        }, ' '),
        placeholder = "{1}",
    })

    local preview = vim.fn["fzf#vim#with_preview"](wrapped)
    preview['sink*'] = function(names)
        for _, name in pairs(names) do
            local num = tonumber(name:match('^[^\t]+\t[^\t]+\t([^\t]+)\t'))
            if num ~= nil then
                pcall(vim.api.nvim_buf_delete, num, {})
            end
        end
    end
    vim.fn["fzf#run"](preview)
end}

-- Ctrl+/ for searching in current buffer.
keymap.nnoremap{'<C-_>', silent=true, function()
    local args = {
        options = '--layout reverse-list --with-nth=4.. --preview-window ' ..
            'nohidden --delimiter=":" --prompt="Current Buffer> "',
    }
    local preview = vim.fn["fzf#vim#with_preview"](args)
    local rg_cmd = table.concat({
        'rg --with-filename --column',
        '   --line-number --no-heading --color=never --smart-case . ',
        vim.fn.fnameescape(vim.fn.expand('%')),
    }, " ")
    vim.fn["fzf#vim#grep"](rg_cmd, 1, preview)
end}

keymap.nnoremap{'<leader>gf', ':GFiles<CR>',  silent=true}
keymap.nnoremap{'<leader>fh', ':History<CR>', silent=true}
-- Run locate.
keymap.nnoremap{'<leader>fl', silent=true, function()
    require('util').user_input{
        prompt = "Term: ",
        on_submit = function(term)
            vim.schedule(function()
                local preview = vim.fn["fzf#vim#with_preview"]()
                vim.fn["fzf#vim#locate"](term, preview)
            end)
        end,
    }
end}

-- Replace the default dictionary completion with fzf-based fuzzy completion.
keymap.inoremap{'<c-x><c-k>', expr=true, [[fzf#vim#complete('cat /usr/share/dict/words-insane')]]}
keymap.imap{'<c-x><c-f>', '<plug>(fzf-complete-path)'}
keymap.imap{'<c-x><c-l>', '<plug>(fzf-complete-line)'}

---Do a ripgrep search with a fzf search interface.
---@param term? string if empty, the search will only happen on the content.
---@param opts string options to pass to ripgrep call.
local function do_rg(term, opts)
    local delimiter = term and ' --delimiter : --nth 4..' or ''
    local args = {
        options = '--prompt="Search Files> " --preview-window nohidden' .. delimiter,
    }
    local preview = vim.fn["fzf#vim#with_preview"](args, 'right:60%:+{2}-/2', 'ctrl-/')
    local rg_cmd = table.concat({
        'rg --column --line-number --no-heading',
        '   --color=always --smart-case --hidden -g "!.git/" ',
        opts or '',
        ' -- ',
        vim.fn.shellescape(term),
    }, " ")
    vim.fn["fzf#vim#grep"](rg_cmd, 1, preview)
end

-- Open the search tool.
keymap.nnoremap{"<leader>ff", function() do_rg("") end}
-- Open the search tool, ignoring .gitignore.
keymap.nnoremap{"<leader>fa", function() do_rg("", '-u') end}
-- Search over current word.
keymap.nnoremap{"<leader>rg", function()
    do_rg(vim.fn.expand("<cword>"))
end}
-- Search over current word, ignoring .gitignore.
keymap.nnoremap{"<leader>ra", function()
    do_rg(vim.fn.expand("<cword>"), '-u')
end}

keymap.nnoremap{'<leader>mm',  ":Marks<CR>"}

keymap.nnoremap{'z=', function()
    local term = vim.fn.expand("<cword>")
    vim.fn["fzf#run"]({
        source = vim.fn.spellsuggest(term),
        sink = function(new_term)
            util.normal('n', '"_ciw' .. new_term .. '')
        end,
        down = 10,
    })
end}

vim.keymap.nnoremap{'<leader>@', function()
    nvim.ex.BTags()
end, silent=true}
