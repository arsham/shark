local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

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

  ls.s(
    { trig = "crit", name = "Scaffold a criterion benchmark" },
    fmt(
      [[
      use criterion::{{black_box, criterion_group, criterion_main, Criterion}};

      pub fn {}(c: &mut Criterion) {{
          c.bench_function("{} {}", |b| b.iter(|| {{
              {}
          }}));
      }}
      criterion_group!({}_bench, {});
      criterion_main!({}_bench);
    ]],
      {
        ls.i(1),
        rep(1),
        ls.i(2),
        ls.i(0),
        rep(1),
        rep(1),
        rep(1),
      }
    )
  ),

  ls.s(
    { trig = "critthrp", name = "Scaffold a criterion benchmark with throughput" },
    fmt(
      [[
      pub fn {}(c: &mut Criterion) {{
          let {} = vec![];
          let mut {} = c.benchmark_group("{}_group");
          for {} in {}.iter() {{
              {}.throughput(Throughput::Bytes(*{} as u64));
              {}.bench_with_input(BenchmarkId::from_parameter({}), {}, |b, &{}| {{
                  b.iter(|| {{
                      {}
                  }});
              }});
          }}
          {}.finish();
      }}
      criterion_group!({}_bench, {});
      criterion_main!({}_bench);
    ]],
      {
        ls.i(1),
        ls.i(2, { "vector" }),
        ls.i(3, { "group" }),
        rep(1), -- benchmark_group("{}_group")
        ls.i(4, { "size" }), -- for {}
        rep(2), -- in {}.iter()
        rep(3), -- {}.throughput()
        rep(4), -- *{} as u64
        rep(4), -- {}.bench_with_input
        rep(4), -- from_parameter({})
        rep(4), -- , {},
        rep(4), -- &{}
        ls.i(0),
        rep(3), -- {}.finish()
        rep(1),
        rep(1),
        rep(1),
      }
    )
  ),

  ls.s(
    { trig = "clapgroup", name = "Scaffold a clap argument setup with groups" },
    fmt(
      [[
      command!()
        .group(ArgGroup::new("{}").multiple(true))
        .next_help_heading("{}")
        .args([
            arg!(--{} "{}").group("{}"),
        ])
      ]],
      {
        ls.i(1, { "group name" }),
        rep(1),
        ls.i(2, { "arg" }),
        ls.i(3, { "description" }),
        rep(1),
      }
    )
  ),

  ls.s(
    { trig = "clapsub", name = "Scaffold a clap argument setup with sub-commands" },
    fmt(
      [[
      let cmd = clap::Command::new("{}")
          .bin_name("{}")
          .subcommand_required(true)
          .subcommand(
              clap::command!("{}").arg(
                  clap::arg!(--"{}" {})
                      .value_parser(clap::value_parser!({})),
              ),
          );
      let matches = cmd.get_matches();
      let matches = match matches.subcommand() {{
          Some(("{}", matches)) => matches,
          _ => {},
      }};
      let manifest_path = matches.get_one::<std::path::PathBuf>("{}");
    ]],
      {
        ls.i(1, { "binary name" }), -- clap::Command::new("{}")
        rep(1), -- bin_name("{}")
        ls.i(2, { "command name" }), -- clap::command!("{}")
        ls.i(3, { "argument" }), -- clap::command!("{}").arg(
        ls.i(4, { "argument" }), -- clap::arg!(--"{*}" {})
        ls.i(5, { "description" }), -- clap::arg!(--"{}" {*})
        rep(2), -- Some(("{}", matches)) => matches,
        ls.i(0, { "todo!()" }),
        rep(3),
      }
    )
  ),
}

-- vim: fdm=marker fdl=0
