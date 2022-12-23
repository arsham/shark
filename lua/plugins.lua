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

  -- Text objects {{{1
  { -- Textobj Comment {{{
    "glts/vim-textobj-comment",
    dependencies = {
      "kana/vim-textobj-user",
    },
    event = { "VeryLazy" },
  }, -- }}}
  -- }}}

  -- Misc {{{
  { -- Tmux {{{
    "tmux-plugins/vim-tmux",
    ft = "tmux",
  }, -- }}}

  { -- Diagon {{{
    -- creates diagrams from text. dependencies diagon from snap.
    "willchao612/vim-diagon",
    cmd = "Diagon",
    enabled = full_start,
  }, -- }}}

  { -- S3 Edit {{{
    "kiran94/s3edit.nvim",
    config = function()
      require("s3edit").setup()
    end,
    cmd = "S3Edit",
  }, -- }}}
  -- }}}
}

-- vim: fdm=marker fdl=1
