local quick = require("arshlib.quick")

local function opts(desc)
  return { silent = true, desc = desc }
end

vim.keymap.set("o", "H", "^", opts("To the beginning of line"))
vim.keymap.set("o", "L", "$", opts("To the end of line"))

vim.keymap.set("n", "J", "mzJ`z", opts("Keep cursor while joining lines"))

-- Moving around {{{
local up = opts("Move lines up")
local down = opts("Move lines down")
vim.keymap.set("i", "<A-j>", [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], down)
vim.keymap.set("i", "<A-k>", [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], up)
vim.keymap.set("n", "<A-j>", [[:<c-u>execute 'm +'. v:count1<cr>==]], down)
vim.keymap.set("n", "<A-k>", [[:<c-u>execute 'm -1-'. v:count1<cr>==]], up)
-- double enter fixes the issues with cmdheight=0
vim.keymap.set("v", "<A-j>", [[:m '>+1<CR><CR>gv=gv]], down)
vim.keymap.set("v", "<A-k>", [[:m '<-2<CR><CR>gv=gv]], up)

local o = opts("Keep the visually selected area when indenting")
vim.keymap.set("x", "<", "<gv", o)
vim.keymap.set("x", ">", ">gv", o)

vim.keymap.set("n", "g=", "gg=Gg``", opts("Re-indent the whole buffer"))
vim.keymap.set("n", "<C-e>", "2<C-e>", opts("Faster scroll up"))
vim.keymap.set("n", "<C-y>", "2<C-y>", opts("Faster scroll down"))
--}}}

-- Resizing windows {{{
vim.keymap.set("n", "<Left>", ":vert resize -2<CR>", opts("Decreases vertical size"))
vim.keymap.set("n", "<Right>", ":vert resize +2<CR>", opts("Increase vertical size"))
vim.keymap.set("n", "<Up>", ":resize +2<CR>", opts("Increase horizontal size"))
vim.keymap.set("n", "<Down>", ":resize -2<CR>", opts("Decreases horizontal size"))
--}}}

o = opts("Auto centre when moving around")
vim.keymap.set("n", "G", "Gzz", o)
vim.keymap.set("n", "g;", "m'g;zz", o)
vim.keymap.set("n", "g,", "m'g,zz", o)

vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>", opts("Clear hlsearch"))

-- Yank related {{{
vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>p", '"+p')
vim.keymap.set("n", "<Leader>P", '"+P')

vim.keymap.set("x", "p", '"_dP', opts('Replace visually selected with the " contents'))
--}}}

vim.keymap.set("n", "<leader>gw", ":silent lgrep <cword> % <CR>", opts("Grep on local buffer"))

-- Language support {{{
-- ]s and [s to jump.
-- zg to ignore.
vim.keymap.set("n", "<leader>sp", function()
  local v = vim.api.nvim_get_option_value("spell", { scope = "local", win = 0 })
  vim.api.nvim_set_option_value("spell", not v, { scope = "local", win = 0 })
end, opts("Toggle spelling"))
vim.keymap.set("n", "<leader>sf", function()
  local spell = vim.api.nvim_get_option_value("spell", { scope = "local", win = 0 })
  vim.api.nvim_set_option_value("spell", true, { scope = "local", win = 0 })
  quick.normal("n", "[s1z=``")
  vim.schedule(function()
    vim.api.nvim_set_option_value("spell", spell, { scope = "local", win = 0 })
  end)
end, opts("Auto correct spelling and jump bak.")) --}}}

vim.keymap.set("n", "<leader>hh", ":h <CR>", opts("Show help for work under the cursor"))

-- Buffer Operations {{{
vim.keymap.set("n", "<C-w>b", ":bd<CR>", opts("Delete current buffer"))
vim.keymap.set("n", "<C-w><C-b>", ":bd<CR>", opts("Delete current buffer"))
vim.keymap.set("n", "<C-w><C-t>", ":tabnew %<CR>", opts("Open current buffer in new tab"))
vim.keymap.set("n", "<C-w>t", ":tabnew %<CR>", opts("Open current buffer in new tab"))
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
vim.keymap.set("n", "<leader>zm", foldexpr("manual"), opts("Set local foldmethod to manual"))
vim.keymap.set("n", "<leader>ze", foldexpr("expr"), opts("Set local foldmethod to expr"))
vim.keymap.set("n", "<leader>zi", foldexpr("indent"), opts("Set local foldmethod to indent"))
vim.keymap.set("n", "<leader>zk", foldexpr("marker"), opts("Set local foldmethod to marker"))
vim.keymap.set("n", "<leader>zs", foldexpr("syntax"), opts("Set local foldmethod to syntax"))
--}}}

-- Undoable break points in insert mode {{{
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", opts("Undoable insert edits"))
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>", opts("Undoable insert edits"))
vim.keymap.set("i", "<M-e>", "<C-g>u<C-o>D", opts("Delete to the end of line"))
vim.keymap.set("i", "<M-a>", "<C-g>u<C-o>de", opts("Delete a word in front"))
local break_points = { ",", ".", ";", ":", "!" }
for _, key in ipairs(break_points) do
  vim.keymap.set("i", key, key .. "<c-g>u", opts("Undoable break point"))
end
-- }}}

-- Command mode improvements {{{
-- Beginning and end of line in `:` command mode
vim.keymap.set("c", "<M-a>", "<home>")
vim.keymap.set("c", "<M-e>", "<end>")

vim.keymap.set("c", "<C-r><C-l>", "<C-r>=getline('.')<CR>", opts("Copy current line"))
-- }}}

vim.keymap.set("n", "<Tab><Tab>", "<C-^>", opts("Switch to the alternative buffer"))

-- Base64 Encode/Decode {{{
vim.keymap.set("x", "<leader>be", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, opts("Base64 encode selection"))

vim.keymap.set("x", "<leader>bd", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0 --ignore-garbage --decode", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, opts("Base64 decode selection"))
--}}}

vim.keymap.set("s", "p", function()
  vim.api.nvim_feedkeys("p", "n", false)
end, { silent = true, remap = false, desc = "don't paste in select mode" })

vim.keymap.set("n", "<leader>us", ":UnlinkSnippets<CR>", opts("Unlink all open snippet sessions"))

vim.keymap.set("i", "<C-s>", function()
  vim.cmd.stopinsert()
  local spell = vim.opt.spell:get()
  vim.schedule(function()
    vim.opt.spell = true
    quick.normal("n", "[s1z=``")
    vim.opt_local.spell = spell
    quick.normal("n", "a")
  end)
end, { desc = "Fix spelling mistake and come back" })

-- vim: fdm=marker fdl=0
