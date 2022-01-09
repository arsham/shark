local quick = require("arshlib.quick")

--vim.v.count
--vim.api.nvim_put(t, 'l', true, false)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disabling arrows {{{
vim.keymap.set("n", "<Up>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Down>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Left>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("n", "<Right>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Up>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Down>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Left>", "<Nop>", { noremap = true, desc = "disabling arrows" })
vim.keymap.set("i", "<Right>", "<Nop>", { noremap = true, desc = "disabling arrows" })
-- }}}
-- Moving aroung {{{
-- stylua: ignore start
vim.keymap.set("i", "<A-j>", [[<Esc>:<c-u>execute 'm +'. v:count1<cr>==gi]], { noremap = true, silent = true, desc = "move lines down" })
vim.keymap.set("i", "<A-k>", [[<Esc>:<c-u>execute 'm -1-'. v:count1<cr>==gi]], { noremap = true, silent = true, desc = "move lines up" })

vim.keymap.set("x", "<", "<gv",{noremap=true, desc = "Keep the visually selected area when indenting" })
vim.keymap.set("x", ">", ">gv",{noremap=true, desc = "Keep the visually selected area when indenting" })

vim.keymap.set("n", "g=", "gg=Gg``",{noremap=true, desc = "Re-indent the whole buffer" })
-- stylua: ignore end
vim.keymap.set("n", "<C-e>", "2<C-e>", { noremap = true })
vim.keymap.set("n", "<C-y>", "2<C-y>", { noremap = true })

vim.keymap.set(
  "n",
  "k",
  [[(v:count > 2 ? "m'" . v:count : '') . 'k']],
  { noremap = true, expr = true, desc = "numbered motions in the jumplist" }
)
vim.keymap.set(
  "n",
  "j",
  [[(v:count > 2 ? "m'" . v:count : '') . 'j']],
  { noremap = true, expr = true, desc = "numbered motions in the jumplist" }
)
--}}}

-- Resizing windows {{{
vim.keymap.set(
  "n",
  "<M-Left>",
  ":vert resize -2<CR>",
  { noremap = true, silent = true, desc = "decreases vertical size" }
)
vim.keymap.set(
  "n",
  "<M-Right>",
  ":vert resize +2<CR>",
  { noremap = true, silent = true, desc = "increase vertical size" }
)
vim.keymap.set(
  "n",
  "<M-Up>",
  ":resize +2<CR>",
  { noremap = true, silent = true, desc = "increase horizontal size" }
)
vim.keymap.set(
  "n",
  "<M-Down>",
  ":resize -2<CR>",
  { noremap = true, silent = true, desc = "decreases horizontal size" }
)
--}}}

vim.keymap.set("n", "G", "Gzz", { noremap = true, desc = "Auto re-centre when moving around" })
vim.keymap.set("n", "g;", "m'g;zz", { noremap = true, desc = "Auto re-centre when moving around" })
vim.keymap.set("n", "g,", "m'g,zz", { noremap = true, desc = "Auto re-centre when moving around" })

vim.keymap.set(
  "n",
  "<Esc><Esc>",
  ":noh<CR>",
  { noremap = true, silent = true, desc = "Clear hlsearch" }
)
-- stylua: ignore end

-- Yank related {{{
vim.keymap.set("n", "<Leader>y", '"+y')
vim.keymap.set("x", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>p", '"+p')
vim.keymap.set("n", "<Leader>P", '"+P')

vim.keymap.set(
  "v",
  "p",
  '"_dP',
  { noremap = true, desc = 'replace visually selected with the " contents' }
)
--}}}
vim.keymap.set(
  "n",
  "<leader>gw",
  ":silent lgrep <cword> % <CR>",
  { noremap = true, silent = true, desc = "grep on local buffer" }
)

-- Language support {{{
-- ]s and [s to jump.
-- zg to ignore.
vim.keymap.set("n", "<leader>sp", function()
  vim.wo.spell = not vim.wo.spell
end, { noremap = true, desc = "toggle spelling" })
vim.keymap.set("n", "<leader>sf", function()
  local spell = vim.wo.spell
  vim.wo.spell = true
  quick.normal("n", "[s1z=``")
  vim.schedule(function()
    vim.wo.spell = spell
  end)
end, { noremap = true, desc = "auto correct spelling and jump bak." }) --}}}
-- Merge tool {{{
vim.keymap.set(
  "n",
  "<leader>1",
  ":diffget LOCAL<CR>",
  { noremap = true, desc = "mergetool mapping" }
)
vim.keymap.set(
  "n",
  "<leader>2",
  ":diffget BASE<CR>",
  { noremap = true, desc = "mergetool mapping" }
)
vim.keymap.set(
  "n",
  "<leader>3",
  ":diffget REMOTE<CR>",
  { noremap = true, desc = "mergetool mapping" }
)
--}}}
vim.keymap.set("n", "<leader>jq", ":%!gojq '.'<CR>")

vim.keymap.set(
  "n",
  "<leader>hh",
  ":h <CR>",
  { noremap = true, desc = "Show help for work under the cursor" }
)
-- stylua: ignore end

vim.keymap.set("n", "&", ":&&<CR>", { noremap = true, desc = "repeat last substitute command" })
vim.keymap.set("x", "&", ":&&<CR>", { noremap = true, desc = "repeat last substitute command" })

vim.keymap.set("n", "<C-w>b", ":bd<CR>", { noremap = true, desc = "delete current buffer" })
vim.keymap.set("n", "<C-w><C-b>", ":bd<CR>", { noremap = true, desc = "delete current buffer" })

-- Execute macros over selected range. {{{
vim.keymap.set("x", "@", function()
  local c = vim.fn.getchar()
  local ch = vim.fn.nr2char(c)
  local from = vim.fn.getpos("v")[2]
  local to = vim.fn.getcurpos()[2]
  vim.cmd(string.format("%d,%d normal! @%s", from, to, ch))
end, { noremap = true, silent = false, desc = "execute macro over visual range" })
-- }}}

-- Easier cgn process by starting with already selected text.
vim.keymap.set("n", "cn", "*``cgn")

-- Folding support {{{
vim.keymap.set("n", "<leader>zm", function()
  vim.opt_local.foldmethod = "manual"
end, { noremap = true, silent = true, desc = "set local foldmethod to manual" })

vim.keymap.set("n", "<leader>ze", function()
  vim.opt_local.foldmethod = "expr"
end, { noremap = true, silent = true, desc = "set local foldmethod to expr" })

vim.keymap.set("n", "<leader>zi", function()
  vim.opt_local.foldmethod = "indent"
end, { noremap = true, silent = true, desc = "set local foldmethod to indent" })

vim.keymap.set("n", "<leader>zk", function()
  vim.opt_local.foldmethod = "marker"
end, { noremap = true, silent = true, desc = "set local foldmethod to marker" })

vim.keymap.set("n", "<leader>zs", function()
  vim.opt_local.foldmethod = "syntax"
end, { noremap = true, silent = true, desc = "set local foldmethod to syntax" })
--}}}
-- vim: foldmethod=marker
