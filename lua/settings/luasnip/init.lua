local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.add_snippets("all", require("settings.luasnip.all"))
ls.add_snippets("go", require("settings.luasnip.go"))
ls.add_snippets("lua", require("settings.luasnip.lua"))
ls.add_snippets("gitcommit", require("settings.luasnip.gitcommit"))
ls.add_snippets("markdown", require("settings.luasnip.markdown"))

vim.schedule(function()
  require("luasnip.loaders.from_vscode").load()
end)

ls.config.set_config({ --{{{
  store_selection_keys = "<c-s>",
  updateevents = "TextChanged,TextChangedI",
  ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " ", "TSTextReference" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { " ", "TSEmphasis" } },
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
