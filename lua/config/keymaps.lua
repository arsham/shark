local function opts(desc)
  return { silent = true, desc = desc }
end

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
--}}}

-- vim: fdm=marker fdl=0
