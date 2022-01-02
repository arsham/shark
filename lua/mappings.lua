local util = require('util')

---vim.v.count
---vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--{{{ Disabling arrows
util.noremap{'<Up>',     '<Nop>', desc='disabling arrows'}
util.noremap{'<Down>',   '<Nop>', desc='disabling arrows'}
util.noremap{'<Left>',   '<Nop>', desc='disabling arrows'}
util.noremap{'<Right>',  '<Nop>', desc='disabling arrows'}
util.inoremap{'<Up>',    '<Nop>', desc='disabling arrows'}
util.inoremap{'<Down>',  '<Nop>', desc='disabling arrows'}
util.inoremap{'<Left>',  '<Nop>', desc='disabling arrows'}
util.inoremap{'<Right>', '<Nop>', desc='disabling arrows'}
util.nmap{'Q', '<Nop>', desc='disabling Ex mode'}
--}}}

util.nnoremap{'<A-j>', [[:<c-u>execute 'm +'. v:count1<cr>==]], silent=true, desc='move lines down'}
util.nnoremap{'<A-k>', [[:<c-u>execute 'm -1-'. v:count1<cr>==]], silent=true, desc='move lines up'}
util.inoremap{'<A-j>', [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], silent=true, desc='move lines down'}
util.inoremap{'<A-k>', [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], silent=true, desc='move lines up'}
util.vnoremap{'<A-j>', [[:m '>+1<CR>gv=gv]], silent=true, desc='move lines down'}
util.vnoremap{'<A-k>', [[:m '<-2<CR>gv=gv]], silent=true, desc='move lines up'}

util.xnoremap{'<', '<gv', desc='Keep the visually selected area when indenting'}
util.xnoremap{'>', '>gv', desc='Keep the visually selected area when indenting'}

util.nnoremap{'g=', 'gg=Gg``', desc='Re-indent the whole buffer'}

--{{{ Insert empty lines

---Inserts empty lines near the cursor.
---@param count number  Number of lines to insert.
---@param add number 0 to insert after current line, -1 to insert before current
---line.
local function insert_empty_lines(count, add)
  if count == 0 then
    count = 1
  end
  local lines = {}
  for i = 1,count do
    lines[i] = ''
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, pos[1]+add, pos[1]+add, false, lines)
end

util.nnoremap{']<space>', function()
  insert_empty_lines(vim.v.count, 0)
end, silent=true, desc='insert [count]empty line(s) below current line'}
util.nnoremap{'[<space>', function()
  insert_empty_lines(vim.v.count, -1)
end, silent=true, desc='insert [count]empty line(s) below current line'}
--}}}

util.nnoremap{'<M-Left>',  ':vert resize -2<CR>', silent=true, desc='decreases vertical size'}
util.nnoremap{'<M-Right>', ':vert resize +2<CR>', silent=true, desc='increase vertical size'}
util.nnoremap{'<M-Up>',    ':resize +2<CR>',      silent=true, desc='increase horizontal size'}
util.nnoremap{'<M-Down>',  ':resize -2<CR>',      silent=true, desc='decreases horizontal size'}

util.nnoremap{'<C-e>', '2<C-e>'}
util.nnoremap{'<C-y>', '2<C-y>'}

util.nnoremap{'G',  'Gzz',    desc='Auto re-centre when moving around'}
util.nnoremap{'g;', "m'g;zz", desc='Auto re-centre when moving around'}
util.nnoremap{'g,', "m'g,zz", desc='Auto re-centre when moving around'}

util.nnoremap{'k', [[(v:count > 2 ? "m'" . v:count : '') . 'k']], expr=true, desc='numbered motions in the jumplist'}
util.nnoremap{'j', [[(v:count > 2 ? "m'" . v:count : '') . 'j']], expr=true, desc='numbered motions in the jumplist'}

util.nnoremap{'<Esc><Esc>', ':noh<CR>', silent=true, desc='Clear hlsearch'}

--{{{ Add/remove to/from the end of line(s)
---Add char at the end of a line at the `loc` location.
---@param loc number line number to add the char at.
---@param char string char to add.
---@param content string current content of the line.
---@param remove boolean if false, the char is added, otherwise the last
---character is removed.
local function end_of_line(loc, content, char, remove)
  if remove and (content:sub(-1) ~= char) then
    return
  end
  if remove and #content > 0 then
    content = content:sub(1, -2)
  elseif not remove then
    content = content .. char
  end
  vim.api.nvim_buf_set_lines(0, loc-1, loc, false, {content})
end

---Add the char at the end of the line, or the visually selected area.
---@param name string the name of mapping to repeat.
---@param char string char to add.
---@param remove boolean if false, the char is added, otherwise the last
---character is removed.
local function change_line_ends(name, char, remove)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'n' or mode == 'i' then
    local loc = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    end_of_line(loc[1], line, char, remove)
  elseif mode == "V" or mode == "CTRL-V" or mode == "v" then
    local start = vim.fn.getpos("v")[2]
    local finish = vim.fn.getcurpos()[2]
    if finish < start then
      start, finish = finish, start
    end
    start = start - 1
    local lines = vim.api.nvim_buf_get_lines(0, start, finish, false)

    for k, line in ipairs(lines) do
      end_of_line(start + k, line, char, remove)
    end
  end

  local key = vim.api.nvim_replace_termcodes(name, true, false, true)
  vim.fn["repeat#set"](key, vim.v.count)
end

---Add coma at the end of the line, or the visually selected area.
local end_mapping = {
  ['Period']    = {'.', '>'},
  ['Coma']      = {',', 'lt'},
  ['SemiColon'] = {';', ':'},
}
for n, tuple in pairs(end_mapping) do
  local name1 = string.format('<Plug>AddEnd%s', n)
  local key1  = '<M-' .. tuple[1] .. '>'
  local desc = string.format('Add %s at the end of line', n)
  util.nnoremap{name1, function()
    change_line_ends(name1, tuple[1])
  end, desc=desc}
  util.nmap{key1, name1, desc=desc}
  util.inoremap{key1, function()
    change_line_ends(name1, tuple[1])
  end, desc=desc}
  util.vnoremap{name1, function()
    change_line_ends(name1, tuple[1])
  end, desc=desc}
  util.vmap{key1, name1, desc=desc}

  local name2 = string.format('<Plug>DelEnd%s', n)
  local key2  = '<M-' .. tuple[2] .. '>'
  desc = string.format('Remove %s from the end of line', n)
  util.nnoremap{name2, function()
    change_line_ends(name2, tuple[1], true)
  end, desc=desc}
  util.nmap{key2, name2, desc=desc}
  util.inoremap{key2, function()
    change_line_ends(name2, tuple[1], true)
  end, desc=desc}
  util.vnoremap{name2, function()
    change_line_ends(name2, tuple[1], true)
  end, desc=desc}
  util.vmap{key2, name2, desc=desc}
end
--}}}

util.inoremap{'<M-{>', '<Esc>A {<CR>}<Esc>O', desc='Insert a pair of brackets and go into insert mode'}
util.nnoremap{'<M-{>', 'A {<CR>}<Esc>O', desc='Insert a pair of brackets and go into insert mode'}

util.nnoremap{'<Leader>y', '"+y'}
util.xnoremap{'<Leader>y', '"+y'}
util.nnoremap{'<Leader>p', '"+p'}
util.nnoremap{'<Leader>P', '"+P'}

util.vnoremap{'p', '"_dP', desc='select a text, and this will replace it with the " contents'}

util.nnoremap{'<leader>gw', ':silent lgrep <cword> % <CR>', silent=true, desc='grep on local buffer'}

---]s and [s to jump.
---zg to ignore.
util.nnoremap{'<leader>sp', function()
  vim.wo.spell = not vim.wo.spell
end, desc='toggle spelling'}
util.nnoremap{'<leader>sf', function()
  local spell = vim.wo.spell
  vim.wo.spell = true
  util.normal('n', "[s1z=``")
  vim.schedule(function()
    vim.wo.spell = spell
  end)
end, desc='auto correct spelling and jump bak.'}

util.nnoremap{'<leader>1', ':diffget LOCAL<CR>',  desc='mergetool mapping'}
util.nnoremap{'<leader>2', ':diffget BASE<CR>',   desc='mergetool mapping'}
util.nnoremap{'<leader>3', ':diffget REMOTE<CR>', desc='mergetool mapping'}

util.nnoremap{'<leader>jq', ":%!gojq '.'<CR>"}

util.nnoremap{'<leader>hh',  ":h <CR>", desc='Show help for work under the cursor'}

--{{{ Jump along the indents
---Returns the indentation of the next line from the given argument, that is
---not empty. All lines are trimmed before examination.
---@param from number the line number to start from.
---@param step number if positive, the next line is traversed, otherwise the
---previous line.
---@param barier number the maximum I will check. Can be 0 or max lines.
---@return number the indentation of the next line.
local function next_unempty_line(from, step, barier)
  for i = from, barier, step do
    local len = #string.gsub(vim.fn.getline(i), "^%s+", "")
    if len > 0 then
      return vim.fn.indent(i)
    end
  end
  return 0
end

---Jumps to the next indentation level equal to current line. It skips empty
---lines, unless the next non-empty line has a lower indentation level. If the
---previous indentation is equal to the current one, and current indentation is
---higher than the nest, it will stop.
---@param down boolean indicates whether we are jumping down.
local function jump_indent(down)
  local main_loc    = vim.api.nvim_win_get_cursor(0)[1]
  local main_len    = #string.gsub(vim.fn.getline(main_loc), "^%s+", "")
  local main_indent = main_len > 0 and vim.fn.indent(main_loc) or 0
  local target      = main_loc
  local barrier     = down and vim.api.nvim_buf_line_count(0) or 0
  local step        = down and 1 or -1
  local in_move     = false

  for i = main_loc, barrier, step do
    local line_len = #string.gsub(vim.fn.getline(i), "^%s+", "")

    if line_len ~= 0 then
      local indent      = vim.fn.indent(i)
      local next_len    = #string.gsub(vim.fn.getline(i + step), "^%s+", "")
      local next_indent = next_len > 0 and vim.fn.indent(i + step) or 0
      local prev_empty  = #string.gsub(vim.fn.getline(i - step), "^%s+", "") == 0
      local prev_indent = prev_empty and 0 or vim.fn.indent(i - step)
      local far_indent  = next_unempty_line(i + step*2, step, barrier)

      local on_main_level      = indent        ==  main_indent
      local cruising           = on_main_level and in_move
      local same_level         = indent        ==  prev_indent
      local leveling_up        = indent        >   prev_indent
      local will_go_up         = indent        <   next_indent
      local may_go_up_the_main = next_indent   >=  main_indent
      local will_go_down       = indent        >   next_indent
      local goes_down_the_main = next_indent   <   main_indent
      local later_will_go_down = indent        >   far_indent
      local later_lower_main   = main_indent   >   far_indent
      local prev_not_empty     = next_len      ~=  0
      local next_is_empty      = next_len      ==  0
      local road_block         = will_go_down  and prev_not_empty

      if later_will_go_down and next_is_empty and later_lower_main then
        break
      elseif same_level and on_main_level then
        if road_block then
          --- the next line also coule be empty.
          break
        elseif in_move then
          if will_go_up or goes_down_the_main then
            break
          end
        end
      elseif leveling_up then
        if cruising and prev_empty then
          break
        elseif not may_go_up_the_main and prev_not_empty then
          break
        end
      elseif cruising then
        break
      elseif road_block and not in_move then
        break
      end
    end

    in_move = true
    target = i + step
  end

  local sequence = string.format("%dgg_", target)
  util.normal('xt', sequence)
end

util.nnoremap{']=', function()
  jump_indent(true)
end, desc='jump down along the indent'}
util.nnoremap{'[=', function()
  jump_indent(false)
end, desc='jump up along the indent'}
--}}}

util.nnoremap{'&', ':&&<CR>', desc='repeat last substitute command'}
util.xnoremap{'&', ':&&<CR>', desc='repeat last substitute command'}

util.nnoremap{'<C-w>b',     ':bd<CR>', desc='delete current buffer'}
util.nnoremap{'<C-w><C-b>', ':bd<CR>', desc='delete current buffer'}

--- vim: foldmethod=marker
