return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = { { "gc", mode = { "n", "v" } } },
  opts = {
    pre_hook = function(ctx)
      local cmt_utils = require("Comment.utils")
      local ts_utils = require("ts_context_commentstring.utils")
      local internal = require("ts_context_commentstring.internal")
      -- Determine the location where to calculate commentstring from
      local location = nil
      if ctx.ctype == cmt_utils.ctype.block then
        location = ts_utils.get_cursor_location()
      elseif ctx.cmotion == cmt_utils.cmotion.v or ctx.cmotion == cmt_utils.cmotion.V then
        location = ts_utils.get_visual_start_location()
      end

      -- Detemine whether to use linewise or blockwise commentstring
      local type = ctx.ctype == cmt_utils.ctype.line and "__default" or "__multiline"

      return internal.calculate_commentstring({
        key = type,
        location = location,
      })
    end,
    cond = require("config.util").should_start("numToStr/Comment.nvim"),
    enabled = require("config.util").is_enabled("numToStr/Comment.nvim"),
  },
}
