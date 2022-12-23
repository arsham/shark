-- Disables LSP plugins and other heavy plugins. {{{2
local function full_start()
  return not vim.env.NVIM_START_LIGHT
end
-- }}}
local colorizer_ft = { "css", "scss", "sass", "html", "lua", "markdown", "norg" }

return {
  -- Core/System utilities {{{
  "nvim-lua/plenary.nvim",

  { -- Arshlib {{{
    "arsham/arshlib.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = { "VeryLazy" },
  }, -- }}}

  { -- FZF {{{
    "junegunn/fzf.vim",
    dependencies = "junegunn/fzf",
    event = { "VeryLazy" },
  }, -- }}}

  { -- Listish {{{
    "arsham/listish.nvim",
    dependencies = { "arsham/arshlib.nvim" },
    event = { "VeryLazy" },
    config = function()
      require("listish").config({})
    end,
  }, -- }}}

  { -- Startup Time {{{
    "tweekmonster/startuptime.vim",
    cmd = { "StartupTime" },
  }, -- }}}

  "samjwill/nvim-unception",
  -- }}}

  -- Navigation {{{
  { -- Zoom {{{
    "dhruvasagar/vim-zoom",
    config = function()
      vim.keymap.set("n", "<C-W>z", "<Plug>(zoom-toggle)")
    end,
    keys = { "<C-w>z" },
  }, -- }}}
  -- }}}

  -- Git {{{
  { -- Gist {{{
    -- create ~/.gist-vim with this content: token xxxxx
    "mattn/vim-gist",
    dependencies = {
      { "mattn/webapi-vim", lazy = true },
    },
    config = function()
      vim.g.gist_per_page_limit = 100
    end,
    cmd = { "Gist" },
  }, -- }}}
  -- }}}

  -- Visuals {{{
  { -- Match Maker {{{
    "arsham/matchmaker.nvim",
    dependencies = {
      "arsham/arshlib.nvim",
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },
    config = function()
      require("matchmaker").config({})
    end,
    keys = { "<leader>me", "<leader>ma", "<leader>ml", "<leader>mp" },
    enabled = full_start,
  }, -- }}}

  { -- Devicons {{{
    "kyazdani42/nvim-web-devicons",
    event = { "UIEnter" },
  }, -- }}}

  { -- Colorizer {{{
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = colorizer_ft,
      })
    end,
    ft = colorizer_ft,
    enabled = full_start,
  }, -- }}}

  { -- Nui {{{
    "MunifTanjim/nui.nvim",
    event = { "VeryLazy" },
  }, -- }}}
  -- }}}

  -- Editing {{{
  { -- Yanker {{{
    "arsham/yanker.nvim",
    config = function()
      require("yanker").config({})
    end,
    dependencies = {
      "arsham/arshlib.nvim",
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },
    event = { "VeryLazy" },
    enabled = full_start,
  }, -- }}}

  { -- Repeat {{{
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "vim-scripts/visualrepeat",
    dependencies = { "inkarkat/vim-ingo-library" },
    event = { "BufReadPost", "BufNewFile" },
    enabled = full_start,
  }, -- }}}

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

  -- LSP {{{
  { -- Crates {{{
    "saecki/crates.nvim",
    -- tag = "v0.3.0",
    config = function()
      require("settings.crates-nvim")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = { "BufReadPre Cargo.toml" },
  }, -- }}}

  { -- Inc Rename {{{
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup({
        cmd_name = "Rename",
      })
    end,
    event = { "LspAttach" },
  }, -- }}}
  --}}}

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
  { -- Indent Tools {{{
    "arsham/indent-tools.nvim",
    dependencies = { "arsham/arshlib.nvim" },
    config = function()
      require("indent-tools").config({})
    end,
    event = { "VeryLazy" },
    enabled = full_start,
  }, -- }}}

  { -- Archer {{{
    "arsham/archer.nvim",
    dependencies = { "arsham/arshlib.nvim" },
    config = function()
      require("archer").config({})
    end,
    event = { "VeryLazy" },
  }, -- }}}

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
