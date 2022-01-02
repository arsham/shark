local nvim = require('nvim')
local util = require('util')
local util_lsp = require('util.lsp')
table.insert(vim.opt.rtp, "~/.fzf")

---Shows a fzf search for going to definition. If LSP is not attached, it uses
---the BTags functionality.
---@param lines string[]
local function goto_def(lines)
  local file = lines[1]
  vim.api.nvim_command(("e %s"):format(file))
  if util_lsp.is_lsp_attached() and util_lsp.has_lsp_capability('document_symbol') then
    local ok = pcall(vim.lsp.buf.document_symbol)
    if ok then return end
  end
  nvim.ex.BTags()
end

---Shows a fzf search for going to a line number.
---@param lines string[]
local function goto_line(lines)
  local file = lines[1]
  vim.api.nvim_command(("e %s"):format(file))
  util.normal('n', ':')
end

---Shows a fzf search for line content.
---@param lines string[]
local function search_file(lines)
  local file = lines[1]
  vim.api.nvim_command(("e +BLines %s"):format(file))
end

---Set selected lines in the quickfix/local list with fzf search.
---@param items string[]|table[]
local function insert_into_list(items, is_local)
  local lists = require('lists')
  for _, item in pairs(items) do
    if type(item) == 'string' then
      item = {
        filename = item,
        lnum = 1,
        col  = 1,
        text = "Added with fzf selection",
      }
    end
    lists.insert_list(item, is_local)
  end
end

---Set selected lines in the quickfix list with fzf search.
---@param items string[]|table[]
local function set_qf_list(items)
  insert_into_list(items, false)
  nvim.ex.copen()
end

---Set selected lines in the local list with fzf search.
---@param items string[]|table[]
local function set_loclist(items)
  insert_into_list(items, true)
  nvim.ex.lopen()
end

_G.FzfActions = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit',
  ['alt-q']  = set_qf_list,
  ['alt-w']  = set_loclist,
  ['alt-@']  = goto_def,
  ['alt-:']  = goto_line,
  ['alt-/']  = search_file,
}
vim.g.fzf_action = FzfActions

vim.g.fzf_commands_expect = 'enter'
vim.g.fzf_layout = {
  window = {
    width     = 1,
    height    = 0.5,
    yoffset   = 1,
    highlight = "Comment",
    border    = 'none',
  },
}

vim.g.fzf_buffers_jump = 1          --- [Buffers] Jump to the existing window if possible
vim.g.fzf_preview_window = {'right:50%:+{2}-/2,nohidden', '?'}
vim.g.fzf_commits_log_options = table.concat({
  [[ --graph --color=always                                    ]],
  [[ --format="%C(yellow)%h%C(red)%d%C(reset)                  ]],
  [[ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)" ]],
}, " ")

require('util').augroup{"FZF_FIXES", {
  {"FileType", "fzf", run=function()
    util.tnoremap{'<esc>', '<C-c>', buffer=true, desc='escape fzf with escape'}
  end},
}}

vim.g.fzf_history_dir = vim.env.HOME .. '/.local/share/fzf-history'
