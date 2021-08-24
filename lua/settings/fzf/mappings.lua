require('astronauta.keymap')
local keymap = vim.keymap
local util = require('util')

keymap.nnoremap{'<leader>:', ':Commands<CR>'}
keymap.nnoremap{'<C-p>',     ':Files<CR>',      silent=true}
keymap.nnoremap{'<M-p>',     ':Files ~/<CR>',   silent=true}
keymap.nnoremap{'<C-b>',     ':Buffers<CR>',    silent=true}
keymap.nnoremap{'<C-_>',     ':BLinesPrev<CR>', silent=true}
keymap.nnoremap{'<M-/>',     ':Lines<CR>',      silent=true}

keymap.nnoremap{'<M-b>', silent=true, function()
    local list = vim.fn.getbufinfo({buflisted = 1})
    local buf_list = {}
    for _, v in pairs(list) do
        local t = {
            tostring(v.bufnr),
            "   ",
            v.name,
        }
        if v.changed > 0 then
            t[2] = "[+]"
        end
        table.insert(buf_list, table.concat(t, " "))
    end

    local wrapped = vim.fn["fzf#wrap"]({
        source = buf_list,
        options = [[--prompt "Delete Buffers > " --multi --bind 'ctrl-a:select-all+accept']],
    })
    wrapped['sink*'] = function(names)
        for _, name in pairs(names) do
            local num = string.match(name, '%d+')
            if num ~= nil then
                pcall(vim.api.nvim_buf_delete, num, {})
            end
        end
    end
    vim.fn["fzf#run"](wrapped)
end}

keymap.nnoremap{'<C-_>', silent=true, function()
    local args = {
        options = '--layout reverse-list --with-nth=4.. --delimiter=":" --prompt="Current Buffer> "',
    }
    local preview = vim.fn["fzf#vim#with_preview"](args, 'right:60%:+{2}-/2', 'ctrl-/')
    local rg_cmd = 'rg --with-filename --column --line-number --no-heading --color=never --smart-case . ' .. vim.fn.fnameescape(vim.fn.expand('%'))
    vim.fn["fzf#vim#grep"](rg_cmd, 1, preview)
end}

keymap.nnoremap{'<leader>gg', ':GGrep<CR>',   silent=true}
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

-- Replace the default dictionary completion with fzf-based fuzzy completion>
keymap.inoremap{'<c-x><c-k>', expr=true, [[fzf#vim#complete('cat /usr/share/dict/words-insane')]]}

local function do_rg(term)
    local args = {
        options = '--prompt="Search Files> " --preview-window nohidden',
    }
    local preview = vim.fn["fzf#vim#with_preview"](args, 'right:60%:+{2}-/2', 'ctrl-/')
    local rg_cmd = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git/" -- ' .. vim.fn.shellescape(term)
    vim.fn["fzf#vim#grep"](rg_cmd, 1, preview)
end
-- Open the search tool.
keymap.nnoremap{"<leader>ff", function() do_rg("") end}
-- Search over current word.
keymap.nnoremap{"<leader>rg", function()
    do_rg(vim.fn.expand("<cword>"))
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
    vim.api.nvim_command(":BTags")
end, silent=true}
