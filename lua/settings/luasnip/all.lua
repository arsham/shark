local ls = require("luasnip")
local util = require("settings.luasnip.util")
local fmt = require("luasnip.extras.fmt").fmt

local function rec_ls() --{{{
  return ls.sn(nil, {
    ls.c(1, {
      ls.t({ "" }),
      ls.sn(
        nil,
        fmt("{}{}={}{}", {
          ls.t(" "),
          ls.i(1, "setting"),
          ls.i(2, "value"),
          ls.d(3, rec_ls, {}),
        })
      ),
    }),
  })
end --}}}

return {
  ls.s( -- Modeline {{{
    { trig = "modeline", dscr = "Add modeline to the file" },
    fmt("vim: {}={}{}", {
      ls.i(1, "setting"),
      ls.i(2, "value"),
      ls.d(3, rec_ls, {}),
    })
  ), --}}}

  ls.s( -- Date {{{
    { trig = "date", name = "Date", dscr = "Insert current date" },
    ls.f(function()
      return os.date()
    end)
  ), --}}}

  ls.s("shrug", { ls.t("¯\\_(ツ)_/¯") }),
  ls.s("crab", { ls.t("🦀") }),

  ls.s({ trig = "pwd", name = "PWD", dscr = "Put CWD" }, { --{{{
    ls.f(util.shell, {}, "pwd"),
  }), --}}}
}

-- vim: fdm=marker fdl=0
