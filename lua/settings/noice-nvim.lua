local noice = require("noice")

local top_right = vim.tbl_deep_extend("force", require("noice.config.views").defaults.mini, {
  timeout = 6000,
  position = {
    row = 0,
  },
  zindex = 60,
  win_options = {
    winblend = 30,
  },
})

local routes = {
  -- Core {{{
  {
    view = "split",
    filter = { min_width = 500 },
  },
  { -- always route any messages with more than 20 lines to the split view
    view = "split",
    filter = { event = "msg_show", min_height = 20 },
  },
  {
    view = "mini",
    filter = { event = "msg_show", kind = "return_prompt" },
  },
  -- }}}
  -- Errors {{{
  { -- when search term is not found.
    filter = { event = "msg_show", kind = "emsg", find = "Pattern not found" },
    opts = { skip = true },
  },
  {
    view = "notify",
    filter = { event = "msg_show", kind = "emsg" },
  },
  {
    view = "notify",
    filter = { event = "msg_show", kind = "echoerr" },
  },
  {
    view = "notify",
    filter = { event = "msg_show", kind = "lua_error" },
  },
  {
    view = "notify",
    filter = { event = "msg_show", kind = "rpc_error" },
  },
  {
    view = "notify",
    filter = { event = "msg_show", kind = "wmsg" },
  },
  -- }}}
  -- Misc {{{
  {
    view = "mini",
    filter = { event = "msg_show", kind = "quickfix" },
  },
  { -- shows macro recording
    view = "top_right",
    filter = { event = "msg_showmode", find = "recording @%w$" },
  },
  -- }}}
}

-- Skippers {{{
local skippers = {
  msg_show = {
    "written", -- hide "written" message
    "%d+ lines indented ?$",
    "%d+ lines to indent... ?$",
    "No active Snippet",
  },
}
for event, msgs in pairs(skippers) do
  for _, msg in ipairs(msgs) do
    table.insert(routes, {
      filter = { event = event, find = msg },
      opts = { skip = true },
    })
  end
end
-- }}}

-- Hijacking notifications {{{
local highjackers = {
  notify = {
    "Reloaded .+.lua ?$",
    "Format request failed, no matching language servers",
  },
  msg_show = {
    "%d+ fewer lines",
    "%d+ more lines",
    "%d+ changes; before",
    "%d+ changes; after",
    "%d+ more lines; before",
    "%d+ more lines; after",
    "%d+ changes; before #%d+  %d+ seconds ago",
    "%d+ lines >ed %d+ time",
    "%d+ lines <ed %d+ time",
    "search hit BOTTOM, continuing at TOP",
  },
}
for event, msgs in pairs(highjackers) do
  for _, msg in ipairs(msgs) do
    table.insert(routes, {
      view = "top_right",
      filter = { event = event, find = msg },
    })
  end
end
-- }}}

noice.setup({
  cmdline = { -- {{{
    enabled = true,
    view = "cmdline",
    opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
    icons = {
      ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
      ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
      [":"] = { icon = " ", hl_group = "DiagnosticInfo", firstc = false },
    },
  },
  -- }}}
  messages = { -- {{{
    enabled = true,
    view = "notify", -- default view for messages
    view_error = "notify", -- view for errors
    view_warn = "notify", -- view for warnings
    view_history = "split", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  -- }}}
  popupmenu = { -- {{{
    enabled = true,
    backend = "nui",
  },
  -- }}}
  history = { -- {{{
    view = "split",
    opts = { enter = true, format = "details" },
    -- if you want to filter items in the history.
    -- filter = { event = "msg_show", ["not"] = { kind = { "search_count", "echo" } } },
  },
  -- }}}
  notify = { -- {{{
    enabled = true,
    view = "notify",
  },
  -- }}}
  lsp_progress = { -- {{{
    enabled = true,
    format = "lsp_progress",
    format_done = "lsp_progress_done",
    throttle = 1000 / 30,
    view = "mini",
  },
  -- }}}
  throttle = 1000 / 30,
  views = { -- {{{
    split = { -- always enter the split when it opens
      enter = true,
    },
    top_right = top_right,
  },
  -- }}}

  routes = routes,
})

-- vim: fdm=marker fdl=0
