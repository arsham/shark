local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")

vim.treesitter.set_query( --{{{
  "go",
  "LuaSnip_Result",
  [[
    [
      (method_declaration result: (_) @id)
      (function_declaration result: (_) @id)
      (func_literal result: (_) @id)
    ]
  ]]
) --}}}

-- transform makes a node from the given text.
local function transform(text, info) --{{{
  local string_sn = function(template, default)
    info.index = info.index + 1
    return ls.sn(info.index, fmt(template, ls.i(1, default)))
  end
  local new_sn = function(default)
    return string_sn("{}", default)
  end

  -- cutting the name if exists.
  if text:find([[^[^\[]*string$]]) then
    text = "string"
  elseif text:find("^[^%[]*map%[[^%]]+") then
    text = "map"
  elseif text:find("%[%]") then
    text = "slice"
  elseif text:find([[ ?chan +[%a%d]+]]) then
    return ls.t("nil")
  end

  -- separating the type from the name if exists.
  local type = text:match([[^[%a%d]+ ([%a%d]+)$]])
  if type then
    text = type
  end

  if text == "int" or text == "int64" or text == "int32" then
    return new_sn("0")
  elseif text == "float32" or text == "float64" then
    return new_sn("0")
  elseif text == "error" then
    if not info then
      return ls.t("err")
    end

    info.index = info.index + 1
    return ls.c(info.index, {
      ls.sn(nil, fmt('errors.Wrap({}, "{}")', { ls.t(info.err_name), ls.i(1) })),
      ls.sn(nil, fmt('errors.Wrapf({}, "{}", {})', { ls.t(info.err_name), ls.i(1), ls.i(2) })),
      ls.t(info.err_name),
    })
  elseif text == "bool" then
    info.index = info.index + 1
    return ls.c(info.index, { ls.i(1, "false"), ls.i(2, "true") })
  elseif text == "string" then
    return string_sn('"{}"', "")
  elseif text == "map" or text == "slice" then
    return ls.t("nil")
  elseif string.find(text, "*", 1, true) then
    return new_sn("nil")
  end

  return ls.t(text)
end --}}}

local get_node_text = vim.treesitter.get_node_text
local handlers = { --{{{
  parameter_list = function(node, info)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
      if idx ~= count - 1 then
        table.insert(result, ls.t({ ", " }))
      end
    end

    return result
  end,

  type_identifier = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
} --}}}

local function return_value_nodes(info) --{{{
  local cursor_node = ts_utils.get_node_at_cursor()
  local scope_tree = ts_locals.get_scope_tree(cursor_node, 0)

  local function_node
  for _, scope in ipairs(scope_tree) do
    if
      scope:type() == "function_declaration"
      or scope:type() == "method_declaration"
      or scope:type() == "func_literal"
    then
      function_node = scope
      break
    end
  end

  if not function_node then
    return
  end

  local query = vim.treesitter.get_query("go", "LuaSnip_Result")
  for _, node in query:iter_captures(function_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end
end --}}}

local M = {}

-- make_return_nodes transforms the given arguments into nodes wrapped in a
-- snippet node.
M.make_return_nodes = function(args) --{{{
  local info = { index = 0, err_name = args[1][1] }
  return ls.sn(nil, return_value_nodes(info))
end --}}}

M.shell = function(_, _, command) --{{{
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end --}}}

M.last_lua_module_section = function(args) --{{{
  local text = args[1][1] or ""
  local split = vim.split(text, ".", { plain = true })

  local options = {}
  for len = 0, #split - 1 do
    local node = ls.t(table.concat(vim.list_slice(split, #split - len, #split), "_"))
    table.insert(options, node)
  end

  return ls.sn(nil, {
    ls.c(1, options),
  })
end --}}}

-- Returns true if the cursor in a function body.
function M.is_in_function() --{{{
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return false
  end
  local expr = current_node

  while expr do
    if expr:type() == "function_declaration" or expr:type() == "method_declaration" then
      return true
    end
    expr = expr:parent()
  end
  return false
end --}}}

-- Returns true if the cursor in a function body in a test file.
function M.is_in_test_function() --{{{
  local filename = vim.fn.expand("%:p")
  if vim.endswith(filename, "_test.go") then
    return M.is_in_function()
  end
  return false
end --}}}

return M

-- vim: fdm=marker fdl=0
