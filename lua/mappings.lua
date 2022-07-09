local quick = require("arshlib.quick")
local util = require("util")

--vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disabling arrows {{{
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("i", "<Up>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("i", "<Down>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("i", "<Left>", "<Nop>", { desc = "disabling arrows" })
vim.keymap.set("i", "<Right>", "<Nop>", { desc = "disabling arrows" })
-- }}}

-- Moving around {{{
-- stylua: ignore start
vim.keymap.set("i", "<A-j>", [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], { silent = true, desc = "move lines down" })
vim.keymap.set("i", "<A-k>", [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], { silent = true, desc = "move lines up" })

vim.keymap.set("x", "<", "<gv", { desc = "keep the visually selected area when indenting" })
vim.keymap.set("x", ">", ">gv", { desc = "keep the visually selected area when indenting" })

vim.keymap.set("n", "g=",    "gg=Gg``", { desc = "re-indent the whole buffer" })
vim.keymap.set("n", "<C-e>", "2<C-e>",  {})
vim.keymap.set("n", "<C-y>", "2<C-y>",  {})
--}}}

-- Resizing windows {{{
vim.keymap.set("n", "<M-Left>",  ":vert resize -2<CR>", { silent = true, desc = "decreases vertical size" })
vim.keymap.set("n", "<M-Right>", ":vert resize +2<CR>", { silent = true, desc = "increase vertical size" })
vim.keymap.set("n", "<M-Up>",    ":resize +2<CR>",      { silent = true, desc = "increase horizontal size" })
vim.keymap.set("n", "<M-Down>",  ":resize -2<CR>",      { silent = true, desc = "decreases horizontal size" })
--}}}

vim.keymap.set("n", "G", "Gzz",     { desc = "auto re-centre when moving around" })
vim.keymap.set("n", "g;", "m'g;zz", { desc = "auto re-centre when moving around" })
vim.keymap.set("n", "g,", "m'g,zz", { desc = "auto re-centre when moving around" })

vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>", { silent = true, desc = "clear hlsearch" })

-- Yank related {{{
vim.keymap.set("n", "<Leader>y", '"+y')
vim.keymap.set("x", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>p", '"+p')
vim.keymap.set("n", "<Leader>P", '"+P')

vim.keymap.set("v", "p", '"_dP',
  { desc = 'replace visually selected with the " contents' }
)
--}}}
vim.keymap.set("n", "<leader>gw", ":silent lgrep <cword> % <CR>",
  { silent = true, desc = "grep on local buffer" }
)
-- stylua: ignore end

-- Language support {{{
-- ]s and [s to jump.
-- zg to ignore.
vim.keymap.set("n", "<leader>sp", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "toggle spelling" })
vim.keymap.set("n", "<leader>sf", function()
  local spell = vim.wo.spell
  vim.wo.spell = true
  quick.normal("n", "[s1z=``")
  vim.schedule(function()
    vim.wo.spell = spell
  end)
end, { desc = "auto correct spelling and jump bak." }) --}}}

-- Merge tool {{{
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("DIFFTOOL", { clear = true }),
  callback = function()
    if vim.opt.diff:get() and not util.buffer_has_var("difftool_special_keys") then
      local o = { buffer = true, desc = "Mergetool mapping" }
      vim.keymap.set("n", "<localleader>1", ":diffget LOCAL<CR>", o)
      vim.keymap.set("n", "<localleader>2", ":diffget BASE<CR>", o)
      vim.keymap.set("n", "<localleader>3", ":diffget REMOTE<CR>", o)
    end
  end,
})
--}}}

vim.keymap.set("n", "<leader>jq", ":%!gojq '.'<CR>")

vim.keymap.set("n", "<leader>hh", ":h <CR>", { desc = "show help for work under the cursor" })

vim.keymap.set("n", "&", ":&&<CR>", { desc = "repeat last substitute command" })
vim.keymap.set("x", "&", ":&&<CR>", { desc = "repeat last substitute command" })

vim.keymap.set("n", "<C-w>b", ":bd<CR>", { desc = "delete current buffer" })
vim.keymap.set("n", "<C-w><C-b>", ":bd<CR>", { desc = "delete current buffer" })

-- Execute macros over selected range. {{{
vim.keymap.set("x", "@", function()
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local from = vim.fn.getpos("v")[2]
  local to = vim.fn.getcurpos()[2]
  vim.cmd(string.format("%d,%d normal! @%s", from, to, ch))
end, { silent = false, desc = "execute macro over visual range" })
-- }}}

-- Easier cgn process by starting with already selected text.
vim.keymap.set("n", "cn", "*``cgn")

-- Make the last change as an initiation for cgn.
vim.keymap.set("n", "g.", [[/\V<C-r>"<CR>cgn<C-a><Esc>]])

-- Folding support {{{
vim.keymap.set("n", "<leader>zm", function()
  vim.opt_local.foldmethod = "manual"
end, { silent = true, desc = "set local foldmethod to manual" })

vim.keymap.set("n", "<leader>ze", function()
  vim.opt_local.foldmethod = "expr"
end, { silent = true, desc = "set local foldmethod to expr" })

vim.keymap.set("n", "<leader>zi", function()
  vim.opt_local.foldmethod = "indent"
end, { silent = true, desc = "set local foldmethod to indent" })

vim.keymap.set("n", "<leader>zk", function()
  vim.opt_local.foldmethod = "marker"
end, { silent = true, desc = "set local foldmethod to marker" })

vim.keymap.set("n", "<leader>zs", function()
  vim.opt_local.foldmethod = "syntax"
end, { silent = true, desc = "set local foldmethod to syntax" })
--}}}

vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", { silent = true, desc = "undoable insert edits" })
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>", { silent = true, desc = "undoable insert edits" })

-- Beginning and end of line in `:` command mode
vim.keymap.set("c", "<M-a>", "<home>", {})
vim.keymap.set("c", "<M-e>", "<end>", {})

vim.keymap.set("n", "<C-S-P>", function()
  require("fzf-lua.providers.nvim").commands()
end, { silent = true, desc = "open command pallete" })

-- Base64 Encode/Decode {{{
vim.keymap.set("v", "<leader>be", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, { desc = "base64 encode selection" })

vim.keymap.set("v", "<leader>bd", function()
  local contents = quick.selection_contents()
  local got = vim.fn.system("base64 --wrap=0 --ignore-garbage --decode", { contents })
  got = got:gsub("\n$", "")
  quick.normal("n", "s" .. got .. "")
end, { desc = "base64 decode selection" })
--}}}

-- vim: fdm=marker fdl=0
