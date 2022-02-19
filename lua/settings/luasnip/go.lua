-- Requires {{{
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local util = require("settings.luasnip.util")
local ai = require("luasnip.nodes.absolute_indexer")
local partial = require("luasnip.extras").partial
--}}}

-- Conditions {{{
local function not_in_function()
  return not util.is_in_function()
end

local in_test_func = {
  show_condition = util.is_in_test_function,
  condition = util.is_in_test_function,
}

local in_test_file = {
  show_condition = util.is_in_test_file,
  condition = util.is_in_test_file,
}

local in_func = {
  show_condition = util.is_in_function,
  condition = util.is_in_function,
}

local not_in_func = {
  show_condition = not_in_function,
  condition = not_in_function,
}
--}}}

-- stylua: ignore start
return {
  -- Main {{{
  ls.s(
    { trig = "main", name = "Main", dscr = "Create a main function" },
    fmta("func main() {\n\t<>\n}", ls.i(0)),
    not_in_func
  ), --}}}

  -- If call error {{{
  ls.s(
    { trig = "ifcall", name = "IF CALL", dscr = "Call a function and check the error" },
    fmt(
      [[
        {val}, {err1} := {func}({args})
        if {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]], {
        val     = ls.i(1, { "val" }),
        err1    = ls.i(2, { "err" }),
        func    = ls.i(3, { "Func" }),
        args    = ls.i(4),
        err2    = rep(2),
        err3    = ls.d(5, util.make_return_nodes, { 2 }),
        finally = ls.i(0),
    }),
    in_func
  ), --}}}

  -- Function {{{
  ls.s(
    { trig = "fn", name = "Function", dscr = "Create a function or a method" },
    fmt(
      [[
        // {name1} {desc}
        func {rec}{name2}({args}) {ret} {{
          {finally}
        }}
      ]], {
        name1 = rep(2),
        desc  = ls.i(5, "description"),
        rec   = ls.c(1, {
          ls.t(""),
          ls.sn(nil, fmt("({} {}) ", {
            ls.i(1, "r"),
            ls.i(2, "receiver"),
          })),
        }),
        name2 = ls.i(2, "Name"),
        args  = ls.i(3),
        ret   = ls.c(4, {
          ls.i(1, "error"),
          ls.sn(nil, fmt("({}, {}) ", {
            ls.i(1, "ret"),
            ls.i(2, "error"),
          })),
        }),
        finally = ls.i(0),
    }),
    not_in_func
  ), --}}}

  -- If error {{{
  ls.s(
    { trig = "ife", name = "If error", dscr = "If error, return wrapped" },
    fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
      ls.i(1, "err"),
      ls.d(2, util.make_return_nodes, { 1 }),
      ls.i(0),
    }),
    in_func
  ), --}}}

  -- gRPC Error{{{
  ls.s(
    { trig = "gerr", dscr = "Return an instrumented gRPC error" },
    fmt('internal.GrpcError({},\n\tcodes.{}, "{}", "{}", {})', {
      ls.i(1, "err"),
      ls.i(2, "Internal"),
      ls.i(3, "Description"),
      ls.i(4, "Field"),
      ls.i(5, "fields"),
    }),
    in_func
  ), --}}}

  -- Mockery {{{
  ls.s(
    { trig = "mockery", name = "Mockery", dscr = "Create an interface for making mocks" },
    fmt(
      [[
        // {} mocks {} interface for testing purposes.
        //go:generate mockery --name {} --filename {}_mock.go
        type {} interface {{
          {}
        }}
      ]], {
        rep(1),
        rep(2),
        rep(1),
        ls.f(function(args) return util.snake_case(args[1][1]) end, { 1 }),
        ls.i(1, "Client"),
        ls.i(2, "pkg.Interface"),
    })
  ), --}}}

  -- Nolint {{{
  ls.s(
    { trig = "nolint", dscr = "ignore linter" },
    fmt([[// nolint:{} // {}]], {
      ls.i(1, "names"),
      ls.i(2, "explaination"),
    })
  ), --}}}

  -- Allocate Slices and Maps {{{
  ls.s(
    { trig = "make", name = "Make", dscr = "Allocate map or slice" },
    fmt("{} {}= make({})\n{}", {
      ls.i(1, "name"),
      ls.i(2),
      ls.c(3, {
        fmt("[]{}, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("[]{}, 0, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("map[{}]{}, {}", { ls.i(1, "keys"), ls.i(2, "values"), ls.i(3, "len") }),
      }),
      ls.i(0),
    }),
    in_func
  ), --}}}

  -- Test Cases {{{
  ls.s(
    { trig = "tcs", dscr = "create test cases for testing" },
    fmta(
      [[
        tcs := map[string]struct {
        	<>
        } {
        	// Test cases here
        }
        for name, tc := range tcs {
        	tc := tc
        	t.Run(name, func(t *testing.T) {
        		<>
        	})
        }
      ]],
      { ls.i(1), ls.i(2) }
    ),
    in_test_func
  ), --}}}

  -- Go CMP {{{
  ls.s(
    { trig = "gocmp", dscr = "Create an if block comparing with cmp.Diff" },
    fmt(
      [[
        if diff := cmp.Diff({}, {}); diff != "" {{
        	t.Errorf("(-want +got):\\n%s", diff)
        }}
      ]], {
        ls.i(1, "want"),
        ls.i(2, "got"),
    }),
    in_test_func
  ), --}}}

  -- Create Mocks {{{
  ls.s(
    { trig = "mock", name = "Mocks", dscr = "Create a mock with defering assertion" },
    fmt("{} := &mocks.{}{{}}\ndefer {}.AssertExpectations(t)\n{}", {
      ls.i(1, "m"),
      ls.i(2, "Mocked"),
      rep(1),
      ls.i(0),
    }),
    in_test_func
  ), --}}}

  -- Require NoError {{{
  ls.s(
    { trig = "noerr", name = "Require No Error", dscr = "Add a require.NoError call" },
    ls.c(1, {
      ls.sn(nil, fmt("require.NoError(t, {})", { ls.i(1, "err") })),
      ls.sn(nil, fmt('require.NoError(t, {}, "{}")', { ls.i(1, "err"), ls.i(2) })),
      ls.sn(nil, fmt('require.NoErrorf(t, {}, "{}", {})', { ls.i(1, "err"), ls.i(2), ls.i(3) })),
    }),
    in_test_func
  ), --}}}

  -- Subtests {{{
  ls.s(
    { trig = "Test", name = "Test/Subtest", dscr = "Create subtests and their function stubs" },
    fmta("func <>(t *testing.T) {\n<>\n}\n\n <>", {
      ls.i(1),
      ls.d(2, util.create_t_run, ai({ 1 })),
      ls.d(3, util.mirror_t_run_funcs, ai({ 2 })),
    }),
    in_test_file
  ), --}}}

  -- Stringer {{{
  ls.s(
    { trig = "strigner", name = "Stringer", dscr = "Create a stringer go:generate" },
    fmt("//go:generate stringer -type={} -output={}_string.go", {
      ls.i(1, "Type"),
      partial(vim.fn.expand, "%:t:r"),
    })
  ), --}}}

  -- Query Database {{{
  ls.s(
    { trig = "queryrows", name = "Query Rows", dscr = "Query rows from database" },
    fmta(
      [[
      const <query1> = `<query2>`
      <ret1> := make([]<type1>, 0, <cap>)

      <err1> := <retrier>.Do(func() error {
      	<rows1>, <err2> := <db>.Query(<ctx>, <query3>, <args>)
      	if errors.Is(<err3>, pgx.ErrNoRows) {
      		return &retry.StopError{Err: <err4>}
      	}
      	if <err5> != nil {
      		return <err6>
      	}
      	defer <rows2>.Close()

      	<ret2> = <ret3>[:0]
      	for <rows3>.Next() {
      		var <doc1> <type2>
      		<err7> := <rows4>.Scan(&<vals>)
      		if <err8> != nil {
      			return <err9>
      		}

      		<last>
      		<ret4> = append(<ret5>, <doc2>)
      	}

      	return <err11>
      })
      return <ret6>, <err12>
      ]], {
        query1  = ls.i(1, "query"),
        query2  = ls.i(2, "SELECT 1"),
        ret1    = ls.i(3, "ret"),
        type1   = ls.i(4, "Type"),
        cap     = ls.i(5, "cap"),
        err1    = ls.i(6, "err"),
        retrier = ls.i(7, "retrier"),
        rows1   = ls.i(8, "rows"),
        err2    = ls.i(9, "err"),
        db      = ls.i(10, "db"),
        ctx     = ls.i(11, "ctx"),
        query3  = rep(1),
        args    = ls.i(12, "args"),
        err3    = rep(9),
        err4    = rep(9),
        err5    = rep(9),
        err6    = ls.d(13, util.go_err_snippet, { 9 }, { msg = "making query" }),
        rows2   = rep(8),
        ret2    = rep(3),
        ret3    = rep(3),
        rows3   = rep(8),
        doc1    = ls.i(14, "doc"),
        type2   = rep(4),
        err7    = ls.i(15, "err"),
        rows4   = rep(8),
        vals    = ls.i(16, "val"),
        err8    = rep(15),
        err9    = ls.d(17, util.go_err_snippet, { 15 }, { msg = "scanning row" }),
        last    = ls.i(0),
        ret4    = rep(3),
        ret5    = rep(3),
        doc2    = rep(14),
        err11   = ls.d(18, util.go_err_snippet, { 8 }, { msg = "iterating rows", postfix = ".Err()" }),
        ret6    = rep(3),
        err12   = ls.d(19, util.go_err_snippet, { 6 }),
    })
  ),
  -- }}}
}
-- stylua: ignore end

-- vim: fdm=marker fdl=0
