local autopairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

autopairs.setup({
  check_ts = true,
  -- will ignore alphanumeric and `.` symbol
  ignored_next_char = "[%w%.]",
  ts_config = {
    lua = { "string", "source" },
  },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
})

local ts_conds = require("nvim-autopairs.ts-conds")
autopairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
-- press % => %% only while inside a comment or string
autopairs.add_rules({
  Rule("|", "|", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
})

local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end
