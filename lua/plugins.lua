-- Disables LSP plugins and other heavy plugins. {{{2
local function full_start()
  return not vim.env.NVIM_START_LIGHT
end
-- }}}

return {
  -- Core/System utilities {{{
  "nvim-lua/plenary.nvim",

  { -- Startup Time {{{
    "tweekmonster/startuptime.vim",
    cmd = { "StartupTime" },
  }, -- }}}

  "samjwill/nvim-unception",
  -- }}}

  -- Visuals {{{
  { -- Devicons {{{
    "kyazdani42/nvim-web-devicons",
    event = { "UIEnter" },
  }, -- }}}

  { -- Nui {{{
    "MunifTanjim/nui.nvim",
    event = { "VeryLazy" },
  }, -- }}}
  -- }}}

  -- Lua Dev {{{1
  { -- Luaref {{{
    "milisims/nvim-luaref",
    ft = { "lua" },
    enabled = full_start,
  }, -- }}}
  -- }}}

  { -- Helm {{{
    "towolf/vim-helm",
    ft = { "yaml" },
  }, -- }}}
  -- }}}
}

-- vim: fdm=marker fdl=1
