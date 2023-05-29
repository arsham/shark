local quick = require("arshlib.quick")

return {
  { -- mini.surround {{{
    "echasnovski/mini.surround",
    event = { "BufRead", "BufNewFile" },
    config = function()
      quick.highlight("MiniSurround", { link = "Substitute" })
      local ts_input = require("mini.surround").gen_spec.input.treesitter
      local surround = require("mini.surround")
      surround.setup({
        n_lines = 40,
        highlight_duration = 1000,

        mappings = {
          add = "gsa",
          delete = "gsd",
          replace = "gsc",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          update_n_lines = "gsn",

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
    end,
    cond = require("config.util").should_start("echasnovski/mini.surround"),
    enabled = require("config.util").is_enabled("echasnovski/mini.surround"),
  }, -- }}}

  { -- mini.trailspace {{{
    "echasnovski/mini.trailspace",
    event = { "BufRead", "BufNewFile" },
    config = function()
      quick.highlight("MiniTrailspace", { link = "ExtraWhitespace" })
      require("mini.trailspace").setup({})
    end,
    cond = require("config.util").should_start("echasnovski/mini.trailspace"),
    enabled = require("config.util").is_enabled("echasnovski/mini.trailspace"),
  }, -- }}}
}

-- vim: fdm=marker fdl=0
