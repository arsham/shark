---@type Quick
local quick = require("arshlib.quick")

local function opts(desc)
  return { silent = true, desc = desc }
end

-- Disabling arrows {{{
local o = opts("disabling arrows")
vim.keymap.set({ "n", "i" }, "<Up>", "<Nop>", o)
vim.keymap.set({ "n", "i" }, "<Down>", "<Nop>", o)
vim.keymap.set({ "n", "i" }, "<Left>", "<Nop>", o)
vim.keymap.set({ "n", "i" }, "<Right>", "<Nop>", o)
-- }}}

-- Moving around {{{
local up = opts("move lines up")
local down = opts("move lines down")
vim.keymap.set("i", "<A-j>", [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], down)
vim.keymap.set("i", "<A-k>", [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], up)
vim.keymap.set("n", "<A-j>", [[:<c-u>execute 'm +'. v:count1<cr>==]], down)
vim.keymap.set("n", "<A-k>", [[:<c-u>execute 'm -1-'. v:count1<cr>==]], up)
-- double enter fixes the issues with cmdheight=0
vim.keymap.set("v", "<A-j>", [[:m '>+1<CR><CR>gv=gv]], down)
vim.keymap.set("v", "<A-k>", [[:m '<-2<CR><CR>gv=gv]], up)

o = opts("keep the visually selected area when indenting")
vim.keymap.set("x", "<", "<gv", o)
vim.keymap.set("x", ">", ">gv", o)

vim.keymap.set("n", "g=", "gg=Gg``", opts("re-indent the whole buffer"))
vim.keymap.set("n", "<C-e>", "2<C-e>")
vim.keymap.set("n", "<C-y>", "2<C-y>")
--}}}

-- Resizing windows {{{
vim.keymap.set("n", "<M-Left>", ":vert resize -2<CR>", opts("decreases vertical size"))
vim.keymap.set("n", "<M-Right>", ":vert resize +2<CR>", opts("increase vertical size"))
vim.keymap.set("n", "<M-Up>", ":resize +2<CR>", opts("increase horizontal size"))
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>", opts("decreases horizontal size"))
--}}}

o = opts("auto re-centre when moving around")
vim.keymap.set("n", "G", "Gzz", o)
vim.keymap.set("n", "g;", "m'g;zz", o)
vim.keymap.set("n", "g,", "m'g,zz", o)

vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>", opts("clear hlsearch"))

-- Yank related {{{
vim.keymap.set("n", "<Leader>y", '"+y')
vim.keymap.set("x", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>p", '"+p')
vim.keymap.set("n", "<Leader>P", '"+P')

vim.keymap.set("x", "p", '"_dP', opts('replace visually selected with the " contents'))
--}}}

vim.keymap.set("n", "<leader>gw", ":silent lgrep <cword> % <CR>", opts("grep on local buffer"))

-- Language support {{{
-- ]s and [s to jump.
-- zg to ignore.
vim.keymap.set("n", "<leader>sp", function()
  vim.wo.spell = not vim.wo.spell
end, opts("toggle spelling"))
vim.keymap.set("n", "<leader>sf", function()
  local spell = vim.wo.spell
  vim.wo.spell = true
  quick.normal("n", "[s1z=``")
  vim.schedule(function()
    vim.wo.spell = spell
  end)
end, opts("auto correct spelling and jump bak.")) --}}}

-- Merge tool {{{
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("DIFFTOOL", { clear = true }),
  callback = function()
    o = opts("Mergetool mapping")
    vim.keymap.set("n", "<localleader>1", ":diffget LOCAL<CR>", o)
    vim.keymap.set("n", "<localleader>2", ":diffget BASE<CR>", o)
    vim.keymap.set("n", "<localleader>3", ":diffget REMOTE<CR>", o)
  end,
})
--}}}

vim.keymap.set("n", "<leader>jq", ":%!gojq '.'<CR>")

vim.keymap.set("n", "<leader>hh", ":h <CR>", opts("show help for work under the cursor"))

vim.keymap.set("n", "<C-w>b", ":bd<CR>", opts("delete current buffer"))
vim.keymap.set("n", "<C-w><C-b>", ":bd<CR>", opts("delete current buffer"))
vim.keymap.set("n", "<C-w><C-t>", ":tabnew %<CR>", opts("open current buffer in new tab"))
vim.keymap.set("n", "<C-w>t", ":tabnew %<CR>", opts("open current buffer in new tab"))
vim.keymap.set("n", "<leader>bd", ":bd<CR>", opts("delete current buffer"))
vim.keymap.set("n", "<leader>bc", ":close<CR>", opts("close current buffer"))
vim.keymap.set("n", "<leader>tb", ":windo bd<CR>", opts("delete all buffers of current tab"))
vim.keymap.set("n", "<leader>tc", ":windo close<CR>", opts("close all buffers of current tab"))

-- Execute macros over selected range. {{{
vim.keymap.set("x", "@", function()
  return ":norm @" .. vim.fn.getcharstr() .. "<cr>"
end, { silent = true, expr = true, desc = "execute macro over visual range" })
-- }}}

-- Easier cgn process by starting with already selected text.
vim.keymap.set("n", "cn", "*``cgn")
vim.keymap.set("x", "cn", function()
  quick.normal("n", 'y/"<CR>Ncgn', true)
end, { silent = true })

-- Make the last change as an initiation for cgn.
vim.keymap.set("n", "g.", [[/\V<C-r>"<CR>cgn<C-a><Esc>]])

-- Folding support {{{
local function foldexpr(value)
  return function()
    vim.opt_local.foldmethod = value
  end
end
vim.keymap.set("n", "<leader>zm", foldexpr("manual"), opts("set local foldmethod to manual"))
vim.keymap.set("n", "<leader>ze", foldexpr("expr"), opts("set local foldmethod to expr"))
vim.keymap.set("n", "<leader>zi", foldexpr("indent"), opts("set local foldmethod to indent"))
vim.keymap.set("n", "<leader>zk", foldexpr("marker"), opts("set local foldmethod to marker"))
vim.keymap.set("n", "<leader>zs", foldexpr("syntax"), opts("set local foldmethod to syntax"))
--}}}

vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", opts("undoable insert edits"))
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>", opts("undoable insert edits"))
vim.keymap.set("i", "<M-e>", "<C-g>u<C-o>D", opts("delete to the end of line"))
vim.keymap.set("i", "<M-a>", "<C-g>u<C-o>de", opts("delete a word in front"))

-- Beginning and end of line in `:` command mode
vim.keymap.set("c", "<M-a>", "<home>")
vim.keymap.set("c", "<M-e>", "<end>")

vim.keymap.set("n", "<C-S-P>", function()
  require("fzf-lua.providers.nvim").commands()
end, opts("open command pallete"))

-- Base64 Encode/Decode {{{
vim.keymap.set("x", "<leader>be", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, opts("base64 encode selection"))

vim.keymap.set("x", "<leader>bd", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0 --ignore-garbage --decode", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, opts("base64 decode selection"))
--}}}

-- Exchange windows {{{
vim.keymap.set("n", "<C-w>y", function()
  local window = vim.api.nvim_win_get_number(0)
  local buffer = vim.api.nvim_buf_get_number(0)
  vim.keymap.set("n", "<C-w>x", function()
    local view = vim.fn.winsaveview()
    local cur_buf = vim.api.nvim_buf_get_number(0)
    local cur_win = vim.api.nvim_win_get_number(0)
    vim.cmd.buffer(buffer)
    vim.api.nvim_command(tostring(window) .. "wincmd w")
    vim.cmd.buffer(cur_buf)
    vim.api.nvim_command(tostring(cur_win) .. "wincmd w")
    vim.fn.winrestview(view)
    vim.keymap.del("n", "<C-w>x")
  end, opts("exchange with yanked buffer"))
end, opts("yank current window for swapping"))
-- }}}

vim.keymap.set("n", "[t", "<cmd>tabprev<cr>")
vim.keymap.set("n", "]t", "<cmd>tabnext<cr>")

vim.keymap.set("n", "<leader>ch", function()
  local height = vim.opt.cmdheight:get()
  if height == 0 then
    height = 1
  else
    height = 0
  end
  vim.opt.cmdheight = height
end, opts("toggle cmdheight value between 0 and 1"))

vim.keymap.set("n", "<leader>sb", function()
  vim.opt_local.scrollbind = not vim.opt_local.scrollbind:get()
end, opts("toggle scroll bind on current buffer"))

vim.keymap.set("s", "p", function ()
  vim.api.nvim_feedkeys("p", "n", false)
end, { silent = true, remap = false, desc = "don't paste in select mode" })

vim.keymap.set("x", "/", "<Esc>/\\%V", { desc = "Search in visually selected region" })

-- vim: fdm=marker fdl=0
