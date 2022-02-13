local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.snippets = { --{{{
  all = require("settings.luasnip.all"),
  go = require("settings.luasnip.go"),
  lua = require("settings.luasnip.lua"),
  gitcommit = require("settings.luasnip.gitcommit"),
  markdown = require("settings.luasnip.markdown"),
} --}}}

require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({ --{{{
  store_selection_keys = "<c-s>",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "TSTextReference" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { "●", "TSEmphasis" } },
      },
    },
  },
}) --}}}

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

-- vim: fdm=marker fdl=0
