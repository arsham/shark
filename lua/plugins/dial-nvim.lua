local function config()
  -- Generate List Function {{{
  ---Returns a list of all characters in the given string.
  ---@param str string The string to get the characters from.
  ---@return table
  local function generate_list(str)
    local ret = {}
    for i = 1, #str, 1 do
      table.insert(ret, str:sub(i, i))
    end
    return ret
  end -- }}}

  -- Increases Decimals {{{
  ---Increases the given number by one.
  ---@param text string The number to increase.
  ---@param addend string The number to add to the given number.
  ---@param prefix string|nil prefix of formatting the number
  ---@return table
  local function increase_decimal(text, addend, prefix)
    local len = #text
    local n = tonumber(text)
    n = n + addend
    if n < 0 then
      n = 0
    end
    if n > (10 ^ len) - 1 then
      n = (10 ^ len) - 1
    end
    prefix = prefix or ""
    local format = "%" .. prefix .. "d"
    text = format:format(n)
    return { text = text, cursor = len }
  end -- }}}

  local augend = require("dial.augend")
  local common = require("dial.augend.common")
  require("dial.config").augends:register_group({
    default = {
      augend.constant.alias.bool,
      augend.date.alias["%-m/%-d"],
      augend.date.alias["%H:%M"],
      augend.date.alias["%H:%M:%S"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%m/%d"],
      augend.hexcolor.new({}),
      augend.integer.alias.binary,
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.semver.alias.semver,

      augend.constant.new({ elements = generate_list("abcdefghijklmnopqrstuvwxyz"), cyclic = true }),
      augend.constant.new({ elements = generate_list("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), cyclic = true }),
      augend.constant.new({
        elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
      }),

      augend.constant.new({ -- Months {{{
        elements = {
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        },
      }), -- }}}

      augend.constant.new({ elements = { "int", "int64", "int32" } }),
      augend.constant.new({ elements = { "float64", "float32" } }),

      -- copied from an old commit from the author of the plugin.
      augend.user.new({ -- Digits {{{
        desc = "fixed-digit decimal natural number (e.g. 00, 01, 02, ..., 97, 98, 99)",
        find = common.find_pattern("%d+"),
        add = function(text, addend)
          return increase_decimal(text, addend, "0")
        end,
      }), -- }}}

      augend.user.new({ -- Markdown Header {{{
        desc = "Markdown Header (# Title)",

        find = function(line)
          local from, to = line:find("^#+")
          if from == nil or to > 7 then
            return nil
          end
          return { from = from, to = to }
        end,

        add = function(text, addend)
          local n = #text
          n = n + addend
          if n < 1 then
            n = 1
          end
          if n > 6 then
            n = 6
          end
          text = ("#"):rep(n)
          return { text = text, cursor = 1 }
        end,
      }), -- }}}
    },
  })

  local dial_map = require("dial.map")
  vim.keymap.set("n", "<C-a>", dial_map.inc_normal(), {})
  vim.keymap.set("n", "<C-x>", dial_map.dec_normal(), {})
  vim.keymap.set("x", "<C-a>", dial_map.inc_visual(), {})
  vim.keymap.set("x", "<C-x>", dial_map.dec_visual(), {})
  vim.keymap.set("x", "g<C-a>", dial_map.inc_gvisual(), {})
  vim.keymap.set("x", "g<C-x>", dial_map.dec_gvisual(), {})
end

return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", mode = { "v", "n" } },
    { "<C-x>", mode = { "v", "n" } },
    { "g<C-a>", mode = "v" },
    { "g<C-x>", mode = "v" },
  },
  config = config,
  enabled = require("config.util").is_enabled("monaqa/dial.nvim"),
}

-- vim: fdm=marker fdl=0
