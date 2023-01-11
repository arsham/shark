local function config()
  local noice = require("noice")
  local mini = require("noice.config.views").defaults.mini
  mini.timeout = 5000
  mini.align = "message-left"

  -- Top Right Setup {{{
  local top_right = vim.tbl_deep_extend("force", mini, {
    timeout = 6000,
    position = {
      row = 1,
    },
    zindex = 60,
    win_options = {
      winblend = 30,
    },
  }) -- }}}

  local error = vim.tbl_deep_extend("force", top_right, {
    timeout = 10000,
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
          { event = "msg_show", kind = "redraw" },
          { event = "msg_show", kind = "search_count" },
          { event = "msg_show", find = "^/[^/]+$" }, -- search display
          { event = "msg_show", find = "/[^/]+/[^ ]+ %d+L, %d+B" },
          { event = "msg_show", kind = "emsg", find = "Pattern not found" }, -- when search term is not found.
          { event = "msg_show", find = "%d+ lines >ed %d+ time" },
          { event = "msg_show", find = "%d+ lines <ed %d+ time" },
        },
      },
    },
    -- }}}
    -- Split {{{
    {
      view = "split",
      filter = {
        any = {
          { min_width = 500 },
          -- always route any messages with more than 20 lines to the split view
          { event = "msg_show", min_height = 20 },
          { event = "msg_show", find = "Last set from .+ line %d+" },
          { event = "msg_show", find = "No mapping found" },
          { event = "msg_show", find = "Last set from Lua" }, -- result of verbose <cmd>
          { event = "msg_show", find = "^/.+/" }, -- filepath
        },
      },
    },
    {
      view = "split",
      opts = { lang = "lua" },
      filter = { event = "notify", kind = "debug" },
    },
    -- }}}
    -- Errors {{{
    {
      view = "error",
      filter = {
        any = {
          { event = "msg_show", kind = "emsg" },
          { event = "msg_show", kind = "echoerr" },
          { event = "msg_show", kind = "lua_error" },
          { event = "msg_show", kind = "rpc_error" },
          { event = "msg_show", kind = "wmsg" },
          { event = "notify", kind = "error" },
        },
      },
    },
    -- }}}
    -- Mini {{{
    {
      view = "mini",
      filter = {
        any = {
          { event = "msg_show", kind = "quickfix" },
          { event = "msg_show", kind = "info", find = "%[tree%-sitter%]" },
          { event = "msg_show", find = "%[nvim%-treesitter%]" },
          { event = "notify", kind = "info", find = "%[mason%-lspconfig.*%]" },
          { event = "msg_show", kind = "return_prompt" },
          { event = "notify", kind = "info", find = "packer.nvim" },
          { event = "notify", kind = "info", find = "%[mason%-tool%-installer%]" },
          { event = "notify", kind = "info", find = "was successfully installed" },
          { event = "notify", kind = "info", find = "was successfully uninstalled" },
          { event = "msg_show", find = "Unception prevented inception!" },
          { event = "msg_show", kind = "echo", find = "^%[VM%] *$" },
          { event = "msg_show", kind = "echo", max_length = 1 },
          { event = "msg_show", find = "%d+ fewer lines" },
          { event = "msg_show", find = "%d+ more lines" },
          { event = "msg_show", find = "%d+ changes?; before" },
          { event = "msg_show", find = "%d+ changes?; after" },
          { event = "msg_show", find = "%d+ more lines?; before" },
          { event = "msg_show", find = "%d+ more lines?; after" },
          { event = "msg_show", find = "%d+ lines? less; before" },
          { event = "msg_show", find = "%d+ changes; before #%d+  %d+ seconds ago" },
          { event = "msg_show", find = "Already at newest change" },
          { event = "msg_show", find = "search hit BOTTOM, continuing at TOP" },
          { event = "msg_show", find = "%d+ lines yanked" },
        },
      },
    },
    -- }}}
    -- Hijacking notifications to top right {{{
    {
      view = "top_right",
      filter = {
        any = {
          { event = "msg_show", find = "fetching" },
          { event = "msg_show", find = "successfully fetched all PR state" },
          { event = "msg_show", find = "Hunk %d+ of %d+" },
          { event = "msg_showmode", find = "recording @%w$" }, -- shows macro recording
        },
      },
    },
    -- }}}
    -- Confirm {{{
    {
      view = "confirm",
      filter = {
        find = "OK to remove",
      },
    },
    -- }}}

    { -- anything that doesn't match goes to top right view.
      view = "top_right",
      filter = {
        any = {
          { event = "msg_show" },
          { event = "notify" },
        },
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
    commands = { -- {{{
      history = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { error = true },
            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp", kind = "message" },
            {
              event = { "msg_show", "notify" },
              ["not"] = {
                kind = { "search_count", "echo" },
              },
            },
          },
        },
      },
      -- :Noice last
      last = {
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {
          event = { "msg_show", "notify" },
          ["not"] = {
            kind = { "search_count", "echo" },
          },
        },
        filter_opts = { count = 1 },
      },
      -- :Noice errors
      errors = {
        -- options for the message history that you get with `:Noice`
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = { error = true },
        filter_opts = { reverse = true },
      },
    }, -- }}}
    notify = { -- {{{
      enabled = true,
      view = "notify",
    },
    -- }}}
    lsp = { -- {{{
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30,
        view = "mini",
      },
      signature = {
        enabled = false,
        auto_open = false,
      },
      hover = {
        enabled = false,
      },
    },
    -- }}}
    throttle = 1000 / 30,
    views = { -- {{{
      split = { -- always enter the split when it opens
        enter = true,
      },
      top_right = top_right,
      error = error,
    },
    -- }}}

    routes = routes,
    presets = { inc_rename = true },
  })
end

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = config,
  event = { "UIEnter" },
}

-- vim: fdm=marker fdl=0
