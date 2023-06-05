-- Tips:
-- Reselect Last                <leader>gS                   |vm-reselect-last|
-- Remove Region                Q                            |vm-remove-region|
-- Add Cursor at Position       \\\                          |vm-add-cursor|
-- Select Right/Left            <S-Right>, <S-Left>          |vm-shift-select|
-- Select All Words             \\A                          |vm-select-all|
-- Slash motion                 g/                           |vm-slash|
-- Find with Regex              \\/                          |vm-regex-search|
-- Toggle Mappings              \\<Space>                    |vm-mappings-toggle|
-- Select Operator              s                            |vm-select-operator|
-- Find Operator                m                            |vm-find-operator|
-- Transposition                \\t                          |vm-transpose|

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
    ["Move Left"] = "<C-H>",
    ["Move Right"] = "<C-L>",
    ["Find Under"] = "<C-n>",
    ["Find Subword Under"] = "<C-n>",
  }

  local group = require("config.util").augroup("VISUAL_MULTI_GROUP")
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
      vim.keymap.del("n", "<Left>", { buffer = 0 })
      vim.keymap.del("n", "<Right>", { buffer = 0 })
      vim.keymap.del("n", "<Up>", { buffer = 0 })
      vim.keymap.del("n", "<Down>", { buffer = 0 })
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
  keys = {
    { "<C-n>", mode = { "n", "v" } },
    { "<space><space>", mode = { "n", "v" } },
    "<C-Down>",
    "<C-Up>",
  },
  enabled = require("config.util").is_enabled("mg979/vim-visual-multi"),
}
