local function config()
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
      vim.cmd("silent! Noice disable")
      vim.g._last_cmdheight = vim.opt.cmdheight:get()
      vim.opt.cmdheight = 1
      local o = { buffer = true, silent = true, desc = "temporarily enabling arrows" }
      vim.keymap.set("n", "<Up>", "<Up>", o)
      vim.keymap.set("n", "<Down>", "<Down>", o)
      vim.keymap.set("n", "<Left>", "<Left>", o)
      vim.keymap.set("n", "<Right>", "<Right>", o)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "visual_multi_exit",
    callback = function()
      vim.cmd("silent! Noice enable")
      vim.opt.cmdheight = vim.g._last_cmdheight
      local o = { silent = true, desc = "disabling arrows" }
      vim.keymap.set("n", "<Up>", "<Nop>", o)
      vim.keymap.set("n", "<Down>", "<Nop>", o)
      vim.keymap.set("n", "<Left>", "<Nop>", o)
      vim.keymap.set("n", "<Right>", "<Nop>", o)
    end,
  })
end

return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_leader = "<space><space>"
  end,
  config = config,
  keys = { "<C-n>", "<C-Down>", "<C-Up>", { "<space><space>", mode = { "n", "v" } } },
  cond = require("util").full_start,
}
