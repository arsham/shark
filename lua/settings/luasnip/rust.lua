local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
  ls.s(
    { trig = "testmod", name = "Create a test module" },
    fmt(
      [[
      #[cfg(test)]
      mod {} {{
          use super::*;

          #[test]
          fn {}() {{
              {}
          }}
      }}
    ]],
      {
        ls.i(1),
        ls.i(2),
        ls.i(0),
      }
    )
  ),
}

-- vim: fdm=marker fdl=0
