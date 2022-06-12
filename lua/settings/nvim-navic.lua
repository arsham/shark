local navic, gps, ok
ok, navic = pcall(require, "nvim-navic")
if not ok then
  return
end
ok, gps = pcall(require, "nvim-gps")
if not ok then
  return
end

local separator = " %#CmpItemKindDefault#▶ %*"

-- stylua: ignore start
local icons = { --{{{
  array         = " ",
  boolean       = "◩ ",
  calendar      = " ",
  class         = " ",
  constant      = " ",
  constructor   = " ",
  container     = " ",
  enum          = "練",
  enumMember    = " ",
  event         = " ",
  field         = " ",
  file          = " ",
  func          = " ",
  interface     = "練",
  key           = " ",
  method        = " ",
  module        = " ",
  namespace     = " ",
  null          = "ﳠ ",
  number        = " ",
  object        = " ",
  operator      = " ",
  package       = " ",
  property      = " ",
  string        = " ",
  struct        = " ",
  table         = " ",
  tag           = " ",
  typeParameter = " ",
  variable      = " ",
  watch         = " ",
} --}}}

gps.setup({ --{{{
  icons = {
    ["array-name"]        = "%#CmpItemKindProperty#" .. icons.array    .. "%*",
    ["boolean-name"]      = "%#CmpItemKindValue#"    .. icons.boolean  .. "%*",
    ["class-name"]        = "%#CmpItemKindClass#"    .. icons.class    .. "%*",
    ["container-name"]    = "%#CmpItemKindProperty#" .. icons.object   .. "%*", -- example: lua tables
    ["date-name"]         = "%#CmpItemKindValue#"    .. icons.calendar .. "%*",
    ["date-time-name"]    = "%#CmpItemKindValue#"    .. icons.table    .. "%*",
    ["float-name"]        = "%#CmpItemKindValue#"    .. icons.number   .. "%*",
    ["function-name"]     = "%#CmpItemKindFunction#" .. icons.func     .. "%*",
    ["inline-table-name"] = "%#CmpItemKindProperty#" .. icons.calendar .. "%*",
    ["integer-name"]      = "%#CmpItemKindValue#"    .. icons.number   .. "%*",
    ["mapping-name"]      = "%#CmpItemKindProperty#" .. icons.object   .. "%*",
    ["method-name"]       = "%#CmpItemKindMethod#"   .. icons.method   .. "%*",
    ["module-name"]       = "%#CmpItemKindModule#"   .. icons.module   .. "%*",
    ["null-name"]         = "%#CmpItemKindField#"    .. icons.field    .. "%*",
    ["number-name"]       = "%#CmpItemKindValue#"    .. icons.number   .. "%*",
    ["object-name"]       = "%#CmpItemKindProperty#" .. icons.object   .. "%*",
    ["sequence-name"]     = "%#CmpItemKindProperty#" .. icons.array    .. "%*",
    ["string-name"]       = "%#CmpItemKindValue#"    .. icons.string   .. "%*",
    ["table-name"]        = "%#CmpItemKindProperty#" .. icons.table    .. "%*",
    ["tag-name"]          = "%#CmpItemKindKeyword#"  .. icons.tag      .. "%*", -- example: html tags
    ["time-name"]         = "%#CmpItemKindValue#"    .. icons.watch    .. "%*",
  },
  languages = {
    ["html"] = false,
  },
  separator = separator,
  depth = 0,
  depth_limit_indicator = "..",
  text_hl = "LineNr",
}) --}}}

navic.setup({ --{{{
  icons = {
    Array         = icons.array,
    Boolean       = icons.boolean,
    Class         = icons.class,
    Constant      = icons.constant,
    Constructor   = icons.constructor,
    Enum          = icons.enum,
    EnumMember    = icons.enumMember,
    Event         = icons.event,
    Field         = icons.field,
    File          = icons.file,
    Function      = icons.func,
    Interface     = icons.interface,
    Key           = icons.key,
    Method        = icons.method,
    Module        = icons.module,
    Namespace     = icons.namespace,
    Null          = icons.null,
    Number        = icons.number,
    Object        = icons.object,
    Operator      = icons.operator,
    Package       = icons.package,
    Property      = icons.property,
    String        = icons.string,
    Struct        = icons.struct,
    TypeParameter = icons.typeParameter,
    Variable      = icons.variable,
  },
  separator = separator,
  highlight = true,
}) --}}}
-- stylua: ignore end

local cache = {}
local function get_name(filename) --{{{
  local ret = cache[filename]
  if ret ~= nil then
    return ret
  end

  ret = filename
  local extension = vim.fn.expand("%:e")
  local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
  if icon ~= nil then
    ret = " %#" .. name .. "#" .. icon .. " " .. filename
  end

  cache[filename] = ret
  return ret
end --}}}

local bar = { --{{{
  provider = function()
    local filename = vim.fn.expand("%:t")
    if filename == "NvimTree_1" then
      return "Nvim Tree"
    end

    local ret = get_name(filename)
    local extra = ""
    if navic.is_available() then
      extra = " " .. navic.get_location()
    end
    if extra == " " and gps.is_available() then
      extra = " " .. gps.get_location()
    end
    return ret .. extra
  end,
} --}}}

local components = {
  active = { { bar } },
  inactive = { { bar } },
}

require("feline").winbar.setup({ components = components })

-- vim: fdm=marker fdl=0
