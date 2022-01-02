local autopairs = require('nvim-autopairs')
local ts_conds = require('nvim-autopairs.ts-conds')
local Rule = require('nvim-autopairs.rule')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')

autopairs.setup{
  check_ts = true,
  --- will ignore alphanumeric and `.` symbol
  ignored_next_char = "[%w%.]",
}
autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
--- press % => %% only while inside a comment or string
autopairs.add_rules({
  Rule("|", "|", "lua")
  :with_pair(ts_conds.is_ts_node({'string','comment'})),
})

cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
