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
  -- Skippers {{{
  {
    opts = { skip = true },
    filter = {
      any = {
        { event = "msg_show", find = "written" },
        { event = "msg_show", find = "%d+ lines indented ?$" },
        { event = "msg_show", find = "%d+ lines to indent... ?$" },
        { event = "msg_show", find = "No active Snippet" },
      },
    },
  },
  -- }}}
  -- Core {{{
  {
    view = "split",
    filter = {
      any = {
        { min_width = 500 },
        -- always route any messages with more than 20 lines to the split view
        { event = "msg_show", min_height = 20 },
      },
    },
  },
  {
    view = "mini",
    filter = {
      any = {
        { event = "msg_show", kind = "return_prompt" },
        { event = "msg_show", kind = "echo" },
        { event = "msg_show", kind = "echomsg" },
      },
    },
  },
  -- }}}
  -- Errors {{{
  { -- when search term is not found.
    filter = { event = "msg_show", kind = "emsg", find = "Pattern not found" },
    opts = { skip = true },
  },
  {
    view = "notify",
    filter = {
      any = {
        { event = "msg_show", kind = "emsg" },
        { event = "msg_show", kind = "echoerr" },
        { event = "msg_show", kind = "lua_error" },
        { event = "msg_show", kind = "rpc_error" },
        { event = "msg_show", kind = "wmsg" },
      },
    },
  },
  -- }}}
  -- Misc {{{
  {
    view = "mini",
    filter = {
      any = {
        { event = "msg_show", kind = "quickfix" },
        { event = "msg_show", find = "[tree-sitter]" },
        { event = "notify", find = "[mason-lspconfig]" },
      },
    },
  },
  -- shows macro recording
  { view = "top_right", filter = { event = "msg_showmode", find = "recording @%w$" } },
  -- }}}

  -- Hijacking notifications {{{
  {
    view = "top_right",
    filter = {
      any = {
        { event = "msg_show", find = "%d+ fewer lines" },
        { event = "msg_show", find = "%d+ more lines" },
        { event = "msg_show", find = "%d+ changes; before" },
        { event = "msg_show", find = "%d+ changes; after" },
        { event = "msg_show", find = "%d+ more lines; before" },
        { event = "msg_show", find = "%d+ more lines; after" },
        { event = "msg_show", find = "%d+ changes; before #%d+  %d+ seconds ago" },
        { event = "msg_show", find = "%d+ lines >ed %d+ time" },
        { event = "msg_show", find = "%d+ lines <ed %d+ time" },
        { event = "msg_show", find = "search hit BOTTOM, continuing at TOP" },
        { event = "msg_show", find = "%d+ lines yanked" },
        -- "%[master .+%] check[\r%s]+%d+ files? changed, %d+ insertions?",
      },
    },
  },
  -- }}}
  {
    view = "confirm", -- any view you want
    filter = {
      find = "OK to remove",
    },
  },
}

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
