-- Disables LSP plugins and other heavy plugins. {{{2
local function full_start()
  return not vim.env.NVIM_START_LIGHT
end
local function lsp_enabled()
  return not vim.env.NVIM_STOP_LSP
end
local function full_start_with_lsp()
  return full_start() and lsp_enabled()
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

  { -- FZF Mania {{{
    "arsham/fzfmania.nvim",
    dependencies = {
      "junegunn/fzf.vim",
      "nvim-lua/plenary.nvim",
      "arsham/arshlib.nvim",
      "arsham/listish.nvim",
      {
        "ibhagwan/fzf-lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
      },
    },
    config = function()
      require("settings.fzfmania")
    end,
    event = { "VeryLazy" },
  }, -- }}}

  { -- BQF {{{
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "junegunn/fzf",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("settings.nvim-bqf")
    end,
    ft = { "qf" },
    enabled = full_start,
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

  { -- Wilder {{{
    "gelguy/wilder.nvim",
    config = function()
      require("settings.wilder")
    end,
    build = ":lua vim.defer_fn(function() vim.cmd.UpdateRemotePlugins() end, 500)",
    event = { "CmdlineEnter" },
  }, -- }}}

  { -- Noice {{{
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("settings.noice-nvim")
    end,
    event = { "UIEnter" },
  }, -- }}}

  "samjwill/nvim-unception",
  -- }}}

  -- Navigation {{{
  { -- NvimTree {{{
    "kyazdani42/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("settings.nvim_tree")
    end,
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    keys = { "<leader>kk", "<leader>kf", "<leader><leader>" },
  }, -- }}}

  { -- Navigator {{{
    "numToStr/Navigator.nvim",
    config = function()
      require("settings.navigator")
    end,
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
  }, -- }}}

  { -- Undo tree {{{
    "mbbill/undotree",
    config = function()
      require("settings.undotree")
    end,
    branch = "search",
    cmd = { "UndotreeShow", "UndotreeToggle" },
    keys = { "<leader>u" },
  }, -- }}}

  { -- Zoom {{{
    "dhruvasagar/vim-zoom",
    config = function()
      vim.keymap.set("n", "<C-W>z", "<Plug>(zoom-toggle)")
    end,
    keys = { "<C-w>z" },
  }, -- }}}
  -- }}}

  -- Git {{{
  { -- Fugitive {{{
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-git",
      "tpope/vim-rhubarb",
    },
    config = function()
      require("settings.fugitive")
    end,
  }, -- }}}

  { -- Git Signs {{{
    "lewis6991/gitsigns.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("settings.gitsigns")
    end,
    event = { "VeryLazy" },
    enabled = full_start,
  }, -- }}}

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
  { -- Arshamiser {{{
    "arsham/arshamiser.nvim",
    config = function()
      require("settings.arshamiser")
    end,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      {
        "feline-nvim/feline.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
      },
    },
  }, -- }}}

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

  { -- Notify {{{
    "rcarriga/nvim-notify",
    config = function()
      require("settings.nvim-notify")
    end,
    event = { "VeryLazy" },
  }, -- }}}

  { -- Nui {{{
    "MunifTanjim/nui.nvim",
    event = { "VeryLazy" },
  }, -- }}}

  { -- Dressing {{{
    "stevearc/dressing.nvim",
    config = function()
      require("settings.dressing")
    end,
    event = { "VeryLazy" },
    enabled = full_start,
  }, -- }}}

  { -- Navic {{{
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("settings.nvim-navic")
    end,
    event = { "LspAttach" },
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

  { -- Visual Multi {{{
    "mg979/vim-visual-multi",
    branch = "master",
    config = function()
      vim.g.VM_leader = "<space><space>"
      require("settings.visual_multi")
    end,
    keys = { "<C-n>", "<C-Down>", "<C-Up>", "<space><space>" },
    enabled = full_start,
  }, -- }}}

  { -- Substitute {{{
    "gbprod/substitute.nvim",
    config = function()
      require("settings.substitute-nvim")
    end,
    keys = { { "cx", "cxx", mode = "n" }, { "X", mode = "v" } },
  }, -- }}}

  { -- Autopairs {{{
    "windwp/nvim-autopairs",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("settings.autopairs")
    end,
    event = { "InsertEnter" },
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

  { -- Matchup {{{
    "andymass/vim-matchup",
    config = function()
      require("settings.vim-matchup")
    end,
    event = { "BufReadPost", "BufNewFile" },
    enabled = full_start,
  }, -- }}}

  { -- Dial {{{
    "monaqa/dial.nvim",
    config = function()
      require("settings.dial-nvim")
    end,
    keys = {
      { "<C-a>", mode = "n" },
      { "<C-x>", mode = "n" },
      { "<C-a>", mode = "v" },
      { "<C-x>", mode = "v" },
      { "g<C-a>", mode = "v" },
      { "g<C-x>", mode = "v" },
    },
    enabled = full_start,
  }, -- }}}
  -- }}}

  -- LSP {{{
  { -- Mason {{{
    "williamboman/mason.nvim",
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        config = function()
          require("settings.mason-nvim")
          require("settings.lsp")
        end,
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "ibhagwan/fzf-lua",
          "jose-elias-alvarez/null-ls.nvim",
        },
      },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/null-ls.nvim",
    },
    event = { "VeryLazy" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- Fidget {{{
    "j-hui/fidget.nvim",
    config = function()
      require("settings.fidget-nvim")
    end,
    event = { "LspAttach" },
  }, -- }}}

  { -- Null LS {{{
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    event = { "LspAttach" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- LSP Lines {{{
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("settings.lsp_lines-nvim")
    end,
    event = { "LspAttach" },
  }, -- }}}

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

  { -- SQLS {{{
    "nanotee/sqls.nvim",
    config = function()
      require("settings.sqls")
    end,
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "sql" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- CMP {{{2
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("settings.luasnip")
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("settings.cmp")
    end,
    event = { "InsertEnter" },
    enabled = full_start_with_lsp,
  }, -- }}}
  --}}}

  -- Treesitter {{{2
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- This is actually the nvim-treesitter config, but it's here to make
        -- lazy loading happy.
        config = function()
          require("settings.treesitter")
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-refactor",
        config = function()
          require("settings.treesitter_refactor")
        end,
      },
      {
        "David-Kunz/treesitter-unit",
        config = function()
          require("settings.treesitter_unit")
        end,
      },
      {
        "nvim-treesitter/playground",
        build = ":TSInstall query",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        enabled = full_start,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
    cmd = "TSUpdate",
    event = { "VeryLazy" },
  },
  -- }}}

  -- Lua Dev {{{1
  { -- Neodev {{{2
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({})
    end,
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "lua" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- Luadev {{{
    "bfredl/nvim-luadev",
    config = function()
      require("settings.nvim-luadev")
    end,
    cmd = { "Luadev" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- Luaref {{{
    "milisims/nvim-luaref",
    ft = { "lua" },
    enabled = full_start,
  }, -- }}}
  -- }}}

  { -- Neotest {{{2
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
    config = function()
      require("settings.neotest")
    end,
    event = { "VeryLazy" },
  }, -- }}}

  { -- Go {{{
    "ray-x/go.nvim",
    config = function()
      require("settings.go-nvim")
    end,
    ft = { "go" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- Comment {{{
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("settings.comment")
    end,
    event = { "BufReadPost", "BufNewFile" },
  }, -- }}}

  { -- Helm {{{
    "towolf/vim-helm",
    ft = { "yaml" },
  }, -- }}}

  -- DAP {{{
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        lazy = true,
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        lazy = true,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
      },
      {
        "leoluz/nvim-dap-go",
        config = function()
          require("dap-go").setup()
        end,
        lazy = true,
      },
    },
    config = function()
      require("settings.nvim-dap")
    end,
    enabled = full_start_with_lsp,
    keys = { "<leader>db", "<leader>dB", "<leader>dl" },
  },
  -- }}}

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

  { -- Mini {{{
    "echasnovski/mini.nvim",
    config = function()
      require("settings.mini-nvim")
    end,
    event = { "VeryLazy" },
    enabled = full_start,
  }, -- }}}

  { -- Textobj Comment {{{
    "glts/vim-textobj-comment",
    dependencies = {
      "kana/vim-textobj-user",
    },
    event = { "VeryLazy" },
  }, -- }}}

  { -- Opsort {{{
    "ralismark/opsort.vim",
    init = function()
      vim.g.opsort_no_mappings = true
    end,
    config = function()
      vim.keymap.set("x", "gso", "<plug>Opsort", { silent = true })
      vim.keymap.set("n", "gso", "<plug>Opsort", { silent = true })
      vim.keymap.set("n", "gsoo", "<plug>OpsortLines", { silent = true })
    end,
    event = { "BufReadPost", "BufNewFile", "InsertEnter" },
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

  { -- Venn {{{
    "jbyuki/venn.nvim",
    config = function()
      require("settings.venn")
    end,
    keys = { "<leader>v" },
    enabled = full_start,
  }, -- }}}

  { -- Neorg {{{
    "nvim-neorg/neorg",
    config = function()
      require("settings.neorg")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
    },
    cmd = { "NeorgStart" },
    keys = { "<leader>oo" },
    enabled = full_start_with_lsp,
  }, -- }}}

  { -- Color Picker {{{
    "ziontee113/color-picker.nvim",
    config = function()
      require("settings.color-picker")
    end,
    keys = { "<leader>cp" },
  }, -- }}}

  { -- GH {{{
    "ldelossa/gh.nvim",
    config = function()
      require("settings.gh-nvim")
    end,
    dependencies = {
      "ldelossa/litee.nvim",
      "ibhagwan/fzf-lua",
    },
    cmd = "GH",
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
