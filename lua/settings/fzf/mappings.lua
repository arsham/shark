local nvim = require('nvim')
local util = require('util')
local fzf = require('settings.fzf.util')

---Ctrl+/ for searching in current buffer.
util.nnoremap{'<leader>:', ':Commands<CR>', desc='show commands'}
util.nnoremap{'<C-_>',     fzf.lines_grep,     silent=true, desc='grep lines of current buffer'}
util.nnoremap{'<M-/>',     ':Lines<CR>',       silent=true, desc='search in lines of all open buffers'}
util.nnoremap{'<C-p>',     ':Files<CR>',       silent=true, desc='show files'}
util.nnoremap{'<M-p>',     ':Files ~/<CR>',    silent=true, desc='show all files in home directory'}
util.nnoremap{'<C-b>',     ':Buffers<CR>',     silent=true, desc='show buffers'}
util.nnoremap{'<M-b>',     fzf.delete_buffer,  silent=true, desc='delete buffers'}
util.nnoremap{'<leader>gf', ':GFiles<CR>',     silent=true, desc='show files in git'}
util.nnoremap{'<leader>fh', ':History<CR>',    silent=true, desc='show history'}

util.nnoremap{'<leader>fl', function()
  require('util').user_input{
    prompt = "Term: ",
    on_submit = function(term)
      vim.schedule(function()
        local preview = vim.fn["fzf#vim#with_preview"]()
        vim.fn["fzf#vim#locate"](term, preview)
      end)
    end,
  }
end, silent=true, desc='run locate'}

---Replace the default dictionary completion with fzf-based fuzzy completion.
util.inoremap{'<c-x><c-k>', [[fzf#vim#complete('cat /usr/share/dict/words-insane')]], expr=true, desc='dict completion'}
util.imap{'<c-x><c-f>', '<Plug>(fzf-complete-path)', desc='path completion'}
util.imap{'<c-x><c-l>', '<Plug>(fzf-complete-line)', desc='line completion'}

util.nnoremap{'<leader>ff', function()
  fzf.ripgrep_search('')
end, desc='find in files'}
util.nnoremap{'<leader>fa', function()
  fzf.ripgrep_search('', true)
end, desc='find in files (ignore .gitignore)'}
util.nnoremap{'<leader>fi', function()
  fzf.ripgrep_search_incremental('', true)
end, desc='incremental search with rg'}

util.nnoremap{"<leader>rg", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"))
end, desc='search over current word'}
util.nnoremap{"<leader>ra", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end, desc='search over current word (ignore .gitignore)'}
util.nnoremap{"<leader>ri", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end, desc='search over current word (ignore .gitignore)'}

util.nnoremap{'<leader>mm', ':Marks<CR>', desc='show marks'}

util.nnoremap{'z=', function()
  local term = vim.fn.expand("<cword>")
  vim.fn["fzf#run"]({
    source = vim.fn.spellsuggest(term),
    sink = function(new_term)
      require('util').normal('n', '"_ciw' .. new_term .. '')
    end,
    down = 10,
  })
end, desc='show spell suggestions'}

util.nnoremap{'<leader>@', nvim.ex.BTags, silent=true, desc='show tags'}
