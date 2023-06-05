return {
  "tamton-aquib/duck.nvim",
  dependencies = {
    "arshlib.nvim",
  },
  cmd = { "Duck", "Cook" },
  config = function()
    local quick = require("arshlib.quick")
    local duck = require("duck")

    quick.command("Duck", function(args)
      local count = args.count
      if count == 0 then
        count = 1
      end
      local fn = duck.hatch
      if #args.args > 0 then
        fn = function()
          duck.hatch(args.args)
        end
      end
      for _ = 1, count, 1 do
        fn()
      end
    end, { count = true, nargs = "?" })

    quick.command("Cook", function(args)
      local count = args.count
      if count == 0 then
        count = 1
      end
      for _ = 1, count, 1 do
        duck.cook()
      end
    end, { count = true })
  end,

  enabled = require("config.util").is_enabled("tamton-aquib/duck.nvim"),
}
