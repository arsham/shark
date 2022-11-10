vim.g.VM_theme = "ocean"
vim.g.VM_highlight_matches = "underline"
vim.g.VM_show_warnings = 0
vim.g.VM_silent_exit = 1
vim.g.VM_default_mappings = 1

vim.g.VM_maps = {
  Undo = "<C-u>",
  Redo = "<C-r>",
  ["Select Operator"] = "v",
  ["Select Cursor Up"] = "<C-K>",
  ["Select Cursor Down"] = "<C-J>",
  ["Move Left"] = "<C-H>",
  ["Move Right"] = "<C-L>",
  ["Find Under"] = "<C-n>",
  ["Find Subword Under"] = "<C-n>",
}

local group = vim.api.nvim_create_augroup("VISUAL_MULTI_GROUP", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "visual_multi_start",
  callback = function()
    vim.cmd.Noice("disable")
    vim.opt.cmdheight = 1
    vim.keymap.set("n", "<Up>", "<Up>", { remap = true, buffer = true })
    vim.keymap.set("n", "<Down>", "<Down>", { remap = true, buffer = true })
    vim.keymap.set("n", "<Left>", "<Left>", { remap = true, buffer = true })
    vim.keymap.set("n", "<Right>", "<Right>", { remap = true, buffer = true })
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "visual_multi_exit",
  callback = function()
    vim.cmd.Noice("enable")
    local o = { silent = true, desc = "disabling arrows" }
    vim.keymap.set("n", "<Up>", "<Nop>", o)
    vim.keymap.set("n", "<Down>", "<Nop>", o)
    vim.keymap.set("n", "<Left>", "<Nop>", o)
    vim.keymap.set("n", "<Right>", "<Nop>", o)
  end,
})
