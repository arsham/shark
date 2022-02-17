-- Requires {{{
local ls = require("luasnip")
local util = require("settings.luasnip.util")
local partial = require("luasnip.extras").partial
--}}}

local function generate_lorem(lines) --{{{
  local ret = {}
  for i = 1, lines + 1, 1 do
    table.insert(
      ret,
      ls.f(function()
        return vim.fn.systemlist("lorem -lines " .. i)
      end)
    )
  end
  return ret
end --}}}

return {
  -- System{{{
  ls.s("time", partial(vim.fn.strftime, "%H:%M:%S")),
  ls.s("date", partial(vim.fn.strftime, "%Y-%m-%d")),
  ls.s("pwd", { partial(util.shell, "pwd") }),
  ls.s({ trig = "uuid", wordTrig = true }, { ls.f(util.uuid), ls.i(0) }),
  ls.s({ trig = "rstr(%d+)", regTrig = true }, {
    ls.f(function(_, snip)
      return util.random_string(snip.captures[1])
    end),
    ls.i(0),
  }),
  --}}}

  -- Lorem Ipsum {{{
  ls.s(
    { trig = "lorem", name = "Lorem Ipsum (Choice)", dscr = "Choose next for more lines" },
    ls.c(1, generate_lorem(20))
  ),
  ls.s(
    {
      trig = "(%d+)lorem",
      name = "Lorem Ipsum",
      regTrig = true,
      dscr = "Start with a count for lines",
    },
    ls.f(function(_, snip)
      local lines = snip.captures[1]
      if not tonumber(lines) then
        lines = 1
      end
      return vim.fn.systemlist("lorem -lines " .. lines)
    end)
  ),
  --}}}

  -- Misc {{{
  ls.s("shrug", { ls.t("¯\\_(ツ)_/¯") }),
  ls.s("angry", { ls.t("(╯°□°）╯︵ ┻━┻") }),
  ls.s("happy", { ls.t("ヽ(´▽`)/") }),
  ls.s("sad", { ls.t("(－‸ლ)") }),
  ls.s("confused", { ls.t("(｡･ω･｡)") }),
  --}}}
}

-- vim: fdm=marker fdl=0
