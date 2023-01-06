local function config()
  ---@type Quick
  local quick = require("arshlib.quick")
  quick.highlight("MiniTrailspace", { link = "ExtraWhitespace" })
  quick.highlight("MiniSurround", { link = "Substitute" })
  quick.highlight("MiniIndentscopeSymbol", { link = "VertSplit" })

  local ts_input = require("mini.surround").gen_spec.input.treesitter
  local surround = require("mini.surround")
  surround.setup({
    n_lines = 40,
    highlight_duration = 1000,

    mappings = {
      add = "ys",
      delete = "ds",
      replace = "cs",
      find = "yf",
      find_left = "yF",
      highlight = "yh",
      update_n_lines = "yn",

      suffix_last = "l", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },

    custom_surroundings = {
      -- Use tree-sitter to search for function call
      f = {
        input = ts_input({ outer = "@call.outer", inner = "@call.inner" }),
      },
      -- Use function to compute surrounding info
      ["*"] = {
        input = function()
          local n_star = surround.user_input("Number of * to find: ")
          local many_star = string.rep("%*", tonumber(n_star) or 1)
          return { many_star .. "().-()" .. many_star }
        end,
        output = function()
          local n_star = surround.user_input("Number of * to output: ")
          local many_star = string.rep("*", tonumber(n_star) or 1)
          return { left = many_star, right = many_star }
        end,
      },
    },
  })

  require("mini.trailspace").setup({})
  require("mini.indentscope").setup({
    draw = {
      delay = 100,
      animation = function()
        return 5
      end,
    },

    mappings = {
      object_scope = "",
      object_scope_with_border = "",
      goto_top = "",
      goto_bottom = "",
    },

    symbol = "╎",
  })

  require("mini.misc").setup({
    make_global = { "put", "put_text" },
  })

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term:\\/\\/*",
    callback = function()
      vim.b.minicursorword_disable = true
    end,
    desc = "disable indentscope in terminal buffers",
  }) --}}}

  require("mini.align").setup({
    mappings = {
      start = "ga",
      start_with_preview = "gA",
    },

    -- Default options controlling alignment process
    options = {
      split_pattern = "",
      justify_side = "left",
      merge_delimiter = "",
    },

    -- Default steps performing alignment (if `nil`, default is used)
    steps = {
      pre_split = {},
      split = nil,
      pre_justify = {},
      justify = nil,
      pre_merge = {},
      merge = nil,
    },
  })
end

return {
  "echasnovski/mini.nvim",
  config = config,
  event = { "VeryLazy" },
  cond = require("util").full_start,
}
