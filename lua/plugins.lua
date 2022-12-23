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

  -- Editing {{{
  { -- Caser {{{
    -- MixedCase/PascalCase:   gsm/gsp
    -- camelCase:              gsc
    -- snake_case:             gs_
    -- UPPER_CASE:             gsu/gsU
    -- Title Case:             gst
    -- Sentence case:          gss
    -- space case:             gs<space>
    -- dash-case/kebab-case:   gs-/gsk
    -- Title-Dash/Title-Kebab: gsK
    -- dot.case:               gs.
    "arthurxavierx/vim-caser",
    keys = { "gs" },
  }, -- }}}

  { -- Sort {{{
    "sQVe/sort.nvim",
    config = function()
      require("sort").setup({
        delimiters = { ",", "|", ";", ":", "s", "t" },
      })
    end,
    cmd = { "Sort" },
  }, -- }}}

  { -- Yank Assasin {{{
    "svban/YankAssassin.vim",
    event = { "VeryLazy" },
    enabled = full_start,
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
  { -- Markdown Preview {{{
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      vim.g.mkdp_browser = "firefox"
    end,
    ft = { "markdown" },
    enabled = full_start,
  }, -- }}}

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
