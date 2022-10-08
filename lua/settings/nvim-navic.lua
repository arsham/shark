local navic, ok
ok, navic = pcall(require, "nvim-navic")
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
    return ret .. extra
  end,
} --}}}

local components = {
  active = { { bar } },
  inactive = { { bar } },
}

vim.schedule(function()
  require("feline").winbar.setup({ components = components })
end)

local ignore_navic = {
  bashls = true,
  dockerls = true,
  ["null-ls"] = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if args.data == nil then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if ignore_navic[client.name] then
      return
    end
    if not client.server_capabilities.documentSymbolProvider then
      return
    end
    navic.attach(client, args.buf)
  end,
})

-- vim: fdm=marker fdl=0
