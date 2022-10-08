local wilder = require("wilder")
vim.opt.wildcharm = vim.fn.char2nr("	") -- tab
wilder.enable_cmdline_enter()
wilder.setup({ modes = { ":" } })

local function init_wilder()
  -- stylua: ignore start
  vim.keymap.set("c", "<TAB>", 'wilder#in_context() ? wilder#next() : "\\<Tab>"', { expr = true })
  vim.keymap.set("c", "<S-TAB>", 'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', { expr = true })
  vim.keymap.set("c", "<C-j>", 'wilder#in_context() ? wilder#next() : "\\<Tab>"', { expr = true })
  vim.keymap.set("c", "<C-k>", 'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', { expr = true })
  -- stylua: ignore end

  wilder.set_option("pipeline", {
    wilder.debounce(10),
    wilder.branch(
      wilder.cmdline_pipeline({
        fuzzy = 1,
        -- set_pcre2_pattern = 1,
      }),
      wilder.python_search_pipeline({
        pattern = "fuzzy",
      })
    ),
  })
  local highlighters = {
    wilder.basic_highlighter(),
  }
  wilder.set_option(
    "renderer",
    wilder.renderer_mux({
      [":"] = wilder.popupmenu_renderer({
        highlighter = highlighters,
        pumblend = 10,
        left = { " ", wilder.popupmenu_devicons() },
      }),
      ["/"] = wilder.wildmenu_renderer({
        highlighter = highlighters,
      }),
      ["?"] = wilder.wildmenu_renderer({
        highlighter = highlighters,
      }),
    })
  )
end

-- Lazy loading the setup.
local wilder_group = vim.api.nvim_create_augroup("WILDER", { clear = true })
vim.api.nvim_create_autocmd(
  "CmdlineEnter",
  { group = wilder_group, pattern = "*", once = true, callback = init_wilder }
)
