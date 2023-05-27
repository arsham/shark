local function opts(desc)
  return { silent = true, desc = desc }
end

vim.keymap.set("o", "H", "^", opts("To the beginning of line"))
vim.keymap.set("o", "L", "$", opts("To the end of line"))

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

-- vim: fdm=marker fdl=0
