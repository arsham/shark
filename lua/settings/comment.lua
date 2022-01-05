local cmt_utils = require("Comment.utils")
local ts_utils = require("ts_context_commentstring.utils")
local internal = require("ts_context_commentstring.internal")

require("Comment").setup({
  pre_hook = function(ctx)
    --- Determine the location where to calculate commentstring from
    local location = nil
    if ctx.ctype == cmt_utils.ctype.block then
      location = ts_utils.get_cursor_location()
    elseif ctx.cmotion == cmt_utils.cmotion.v or ctx.cmotion == cmt_utils.cmotion.V then
      location = ts_utils.get_visual_start_location()
    end

    --- Detemine whether to use linewise or blockwise commentstring
    local type = ctx.ctype == cmt_utils.ctype.line and "__default" or "__multiline"

    return internal.calculate_commentstring({
      key = type,
      location = location,
    })
  end,
})
