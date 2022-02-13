local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local util = require("settings.luasnip.util")

local function not_in_function()
  return not util.is_in_function()
end

return {
  ls.s( -- Main {{{
    { trig = "main", name = "MAIN", dscr = "Create a main function" },
    fmt(
      [[
        func main() {{
          {}
        }}
      ]],
      ls.i(0)
    ),
    { show_condition = not_in_function }
  ), --}}}

  ls.s( -- If call error {{{
    { trig = "ifcall", name = "IF CALL", dscr = "Call a function and check the error" },
    fmt(
      [[
      {}, {} := {}({})
      if {} != nil {{
      	return {}
      }}
      {}
    ]],
      {
        ls.i(1, { "val" }),
        ls.i(2, { "err" }),
        ls.i(3, { "Func" }),
        ls.i(4),
        rep(2),
        ls.d(5, util.make_return_nodes, { 2 }),
        ls.i(0),
      }
    ),
    { show_condition = util.is_in_function }
  ), --}}}

  ls.s( -- Function {{{
    { trig = "fn", name = "Function", dscr = "Create a function or a method" },
    fmt(
      [[
        // {} {}
        func {}{}({}) {} {{
          {}
        }}
      ]],
      {
        rep(2),
        ls.i(5, "description"),
        ls.c(1, {
          ls.t(""),
          ls.sn(
            nil,
            fmt("({} {}) ", {
              ls.i(1, "r"),
              ls.i(2, "receiver"),
            })
          ),
        }),
        ls.i(2, "Name"),
        ls.i(3),
        ls.c(4, {
          ls.i(1, "error"),
          ls.sn(
            nil,
            fmt("({}, {}) ", {
              ls.i(1, "ret"),
              ls.i(2, "error"),
            })
          ),
        }),
        ls.i(0),
      }
    ),
    { show_condition = not_in_function }
  ), --}}}

  ls.s( -- If error {{{
    { trig = "ife", name = "If error", dscr = "If error, return wrapped" },
    fmt(
      [[
        if {} != nil {{
        	return {}
        }}
        {}
      ]],
      {
        ls.i(1, "err"),
        ls.d(2, util.make_return_nodes, { 1 }),
        ls.i(0),
      }
    ),
    { show_condition = util.is_in_function }
  ), --}}}

  ls.s( -- gRPC Error{{{
    { trig = "gerr", dscr = "Return an instrumented gRPC error" },
    fmt(
      [[
        internal.GrpcError({},
          codes.{}, "{}", "{}", {})
      ]],
      {
        ls.i(1, "err"),
        ls.i(2, "Internal"),
        ls.i(3, "Description"),
        ls.i(4, "Field"),
        ls.i(5, "fields"),
      }
    ),
    { show_condition = util.is_in_function }
  ), --}}}

  ls.s( -- Nolint {{{
    { trig = "nolint", dscr = "ignore linter" },
    fmt([[// nolint:{} // {}]], {
      ls.i(1, "names"),
      ls.i(2, "explaination"),
    })
  ), --}}}

  ls.s( -- Allocate Slices and Maps {{{
    { trig = "alloc", name = "Allocate", dscr = "Allocate map or slice" },
    fmt("{} {}= make({})\n{}", {
      ls.i(1, "name"),
      ls.i(2),
      ls.c(3, {
        fmt("[]{}, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("[]{}, 0, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("map[{}]{}, {}", { ls.i(1, "keys"), ls.i(2, "values"), ls.i(3, "len") }),
      }),
      ls.i(0),
    })
  ), --}}}

  ls.s( -- Test Cases {{{
    { trig = "tcs", dscr = "create test cases for testing" },
    fmt(
      [[
        tcs := map[string]struct {{
        	{}
        }} {{
        	// Test cases here
        }}
        for name, tc := range tcs {{
        	tc := tc
        	t.Run(name, func(t *testing.T) {{
        		{}
        	}})
        }}
      ]],
      { ls.i(1), ls.i(2) }
    ),
    { show_condition = util.is_in_test_function }
  ), --}}}

  ls.s( -- Go CMP {{{
    { trig = "gocmp", dscr = "cmp.Diff" },
    fmt(
      [[
        if diff := cmp.Diff({}, {}); diff != "" {{
        	t.Errorf("(-want +got):\\n%s", diff)
        }}
      ]],
      {
        ls.i(1, "want"),
        ls.i(2, "got"),
      }
    ),
    { show_condition = util.is_in_test_function }
  ), --}}}

  ls.s( -- Create Mocks {{{
    { trig = "mock", name = "Mocks", dscr = "Create a mock with defering assertion" },
    fmt(
      [[
        {} := &mocks.{}{{}}
        defer {}.AssertExpectations(t)
        {}
      ]],
      {
        ls.i(1, "m"),
        ls.i(2, "Mocked"),
        rep(1),
        ls.i(0),
      }
    ),
    { show_condition = util.is_in_test_function }
  ), --}}}

  ls.s( -- Require NoError {{{
    { trig = "noerr", name = "Require No Error", dscr = "Add a require.NoError call" },
    ls.c(1, {
      ls.sn(nil, fmt("require.NoError(t, {})", { ls.i(1, "err") })),
      ls.sn(nil, fmt('require.NoError(t, {}, "{}")', { ls.i(1, "err"), ls.i(2) })),
      ls.sn(nil, fmt('require.NoErrorf(t, {}, "{}", {})', { ls.i(1, "err"), ls.i(2), ls.i(3) })),
    }),
    { show_condition = util.is_in_test_function }
  ), --}}}
}

-- vim: fdm=marker fdl=0
